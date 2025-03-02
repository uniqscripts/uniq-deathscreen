let CurrentTimer = 0;
var timerId;
let isDead = false;
let translations = [];
let killer = 'UNKNOWN';

$(function() {
    createUIElements();
    
    setupEventHandlers();
    
    $('#wrapper').hide();
});

function createUIElements() {
    const wrapper = $('#wrapper');
    
    const icon = $('<img>').attr({
        'src': 'https://cdn-icons-png.flaticon.com/512/855/855016.png',
        'draggable': 'false'
    });
    
    const title = $('<h2>').attr('id', 'title');
    const subtitle = $('<h1>').attr('id', 'subtitle');
    const killedByContainer = $('<h3>');
    const killedByText = $('<span>').attr('id', 'killed_by_text');
    const killerElement = $('<span>').attr('id', 'killer');
    const timeElement = $('<h4>').attr('id', 'time').text('00:00');
    
    const acceptToDieBtn = $('<button>').attr('id', 'accept_to_die');
    const acceptToDieIcon = $('<i>').addClass('fa-solid fa-skull');
    const acceptToDieText = $('<span>').attr('id', 'accept_to_die_text');
    
    const callEmergencyBtn = $('<button>').attr('id', 'call_emergency');
    const callEmergencyIcon = $('<i>').addClass('fa-solid fa-phone');
    const callEmergencyText = $('<span>').attr('id', 'call_emergency_text');
    
    killedByContainer.append(killedByText, $('<br>'), killerElement);
    
    acceptToDieBtn.append(acceptToDieIcon, '\u00A0\u00A0', acceptToDieText);
    callEmergencyBtn.append(callEmergencyIcon, '\u00A0\u00A0', callEmergencyText);
    
    wrapper.append(
        icon,
        title,
        subtitle,
        killedByContainer,
        timeElement,
        acceptToDieBtn,
        callEmergencyBtn
    );
    
    updateUITexts();
}

function setupEventHandlers() {
    $('#accept_to_die').click(function() {
        $.post(`https://${GetParentResourceName()}/acceptToDie`);
    });
    
    $('#call_emergency').click(function() {
        $.post(`https://${GetParentResourceName()}/callEmergency`);
        $('#call_emergency').addClass("disabled");
    });
}

function updateUITexts() {
    $('#title').text(translations.Title);
    $('#subtitle').text(translations.Subtitle);
    $('#killed_by_text').text(translations.KilledBy);
    $('#killer').text(killer);
    $('#accept_to_die_text').text(translations.AcceptToDie);
    $('#call_emergency_text').text(translations.CallEmergency);
}

window.addEventListener('message', function(event) {
    let item = event.data;
    if (item.type === "show") {
        if (item.status == true) {
            isDead = true;
            CurrentTimer = 0;
            $('#wrapper').fadeIn();
            $('#call_emergency').removeClass("disabled");
        } else {
            CurrentTimer = 0;
            $('#time').text('00:00');
            isDead = false;
            $("#wrapper").fadeOut();
        }
    } else if (item.type == 'setUPValues') {
        if (item.killer != null) {
            killer = item.killer;
        }
        
        if (item.translations) {
            translations = item.translations;
        }
    
        updateUITexts();
        
        clearTimeout(timerId);
        timerId = setInterval(timer, 1000);
        CurrentTimer = item.timer;
    }
});

function timer() {
    if (isDead) {
        if (CurrentTimer < 0) {
            $("#wrapper").fadeOut();
            $.post(`https://${GetParentResourceName()}/timeExpired`);
            clearTimeout(timerId);
            CurrentTimer = 0;
            isDead = false;
        } else {
            $('#time').text(new Date(CurrentTimer * 1000).toISOString().substr(14, 5));
            CurrentTimer = CurrentTimer - 1;
        }
    }
}
