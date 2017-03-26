window.countdownTimerId = null
window.lastFocus = true
window.lastUpdated = null
window.titlePrefix = document.title

$ ->		
  updateTimerDisplay(window.remainingSeconds)
  if isCountingDown == "true"
    countdownTimerId = setInterval ->
      if window.remainingSeconds > 0
        window.remainingSeconds -= 1
      else
        clearInterval(countdownTimerId)
        # $('#time-control').hide()
        $('#done-desc').show()

      updateTimerDisplay(window.remainingSeconds)

      if isFocusGained() == true || isResumed() == true
        synchronizeTimer()

      window.lastFocus   = hasFocus()
      window.lastUpdated = currentTime()
    , 1000
  $('#done-desc').hide() if window.remainingSeconds > 0
  $("#done-desc").keyup (e) ->
    if e.keyCode == 13
      descDone()
  if window.showDesc == "true"
    $('#done-desc').show()
    $('#time-control').hide()

isFocusGained = ->
  hasFocus() == true && window.lastFocus == false

isResumed = ->
  currentTime() - window.lastUpdated > 5000

currentTime = ->
  new Date().getTime()

hasFocus = ->
  window.document.hasFocus()

synchronizeTimer = ->
  $.ajax
    async: true
    type: "GET"
    url: "/timers/" + timerId
    success: (data, status, xhr) ->
      window.remainingSeconds = parseInt(data.remaining_seconds)
      # refreshScreen() if window.remainingSeconds <= 0
refreshScreen = ->
  location.reload()

updateTimerDisplay = (remainingSeconds) ->
  timerString = convertSecondsToTimer(remainingSeconds)
  $("#timer-time").text(timerString)
  document.title = window.titlePrefix + " " + timerString

convertSecondsToTimer = (count) ->
  minutes = Math.floor(count / 60)
  seconds = count % 60
  return addZeroPadding(minutes) + ":" + addZeroPadding(seconds)

addZeroPadding = (number) ->
  string = "00" + String(number);
  return string.substr(string.length - 2);

descDone = ->
  $.ajax
    async: true
    dataType: 'json'
    data: {done_desc: $("#done-desc").val()}
    type: "PATCH"
    url: "/timers/" + timerId
    success: (data, status, xhr) ->
      refreshScreen()