/* CampusAid UI JavaScript Interactions */

document.addEventListener('DOMContentLoaded', function () {
    // 1. Mobile Sidebar Toggle
    var toggleBtn = document.getElementById('mobileSidebarToggle');
    var sidebar = document.querySelector('.app-sidebar');
    if (toggleBtn && sidebar) {
        toggleBtn.addEventListener('click', function () {
            sidebar.classList.toggle('show-mobile');
        });
    }

    // 2. SOS 3-Second Press & Hold Interaction
    initSosButton();

    // 3. Geolocation Coordinate Detection for Forms & SOS
    initGeolocation();
});

function initSosButton() {
    var sosBtn = document.getElementById('sosPressButton');
    var sosTimerDisplay = document.getElementById('sosCountdown');
    var sosHiddenSubmit = document.getElementById('btnHiddenSosSubmit');

    if (!sosBtn) return;

    var pressTimer = null;
    var count = 3;
    var isTriggered = false;

    function startPress(e) {
        if (isTriggered) return;
        sosBtn.classList.add('active-press');
        count = 3;
        if (sosTimerDisplay) sosTimerDisplay.innerText = 'Hold ' + count + 's...';

        pressTimer = setInterval(function () {
            count--;
            if (count > 0) {
                if (sosTimerDisplay) sosTimerDisplay.innerText = 'Hold ' + count + 's...';
            } else {
                clearInterval(pressTimer);
                isTriggered = true;
                if (sosTimerDisplay) sosTimerDisplay.innerText = 'DISPATCHING...';
                sosBtn.style.background = '#059669';
                if (sosHiddenSubmit) {
                    sosHiddenSubmit.click();
                }
            }
        }, 1000);
    }

    function cancelPress(e) {
        if (isTriggered) return;
        sosBtn.classList.remove('active-press');
        if (pressTimer) {
            clearInterval(pressTimer);
            pressTimer = null;
        }
        if (sosTimerDisplay) sosTimerDisplay.innerText = 'Press 3 Sec';
    }

    sosBtn.addEventListener('mousedown', startPress);
    sosBtn.addEventListener('mouseup', cancelPress);
    sosBtn.addEventListener('mouseleave', cancelPress);

    sosBtn.addEventListener('touchstart', function (e) {
        e.preventDefault();
        startPress(e);
    });
    sosBtn.addEventListener('touchend', cancelPress);
    sosBtn.addEventListener('touchcancel', cancelPress);
}

function initGeolocation() {
    var locField = document.getElementById('hfCurrentLocation');
    if (navigator.geolocation && locField) {
        navigator.geolocation.getCurrentPosition(
            function (pos) {
                var coords = 'Lat: ' + pos.coords.latitude.toFixed(4) + ', Lng: ' + pos.coords.longitude.toFixed(4);
                locField.value = coords;
            },
            function (err) {
                // Keep default or fallback campus quad
                console.log('GPS unavailable or permission denied, using campus landmark coordinates.');
            },
            { timeout: 5000 }
        );
    }
}

// Locate Modal for resources
function showLocateModal(resourceName, locationText) {
    var titleEl = document.getElementById('modalResourceName');
    var locEl = document.getElementById('modalResourceLocation');
    var modalEl = document.getElementById('locateModal');

    if (titleEl) titleEl.innerText = resourceName;
    if (locEl) locEl.innerText = locationText;

    if (modalEl && typeof bootstrap !== 'undefined' && bootstrap.Modal) {
        var modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
        modal.show();
    } else {
        alert('Campus Navigation / Map Locator:\n\nResource: ' + resourceName + '\nLocation: ' + locationText + '\n\nOpening campus wayfinding directions...');
    }
}
