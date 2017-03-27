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
        notifyPomorodoDone()
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
  return addZeroPadding(minutes) #+ ":" + addZeroPadding(seconds)

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
notifyPomorodoDone = ->
  options = {
      body: '一个番茄已经完成,请记录刚刚完成的工作,稍作休息继续!'
    }
  if !('Notification' of window)
    alert '不支持该浏览器!'
  else if Notification.permission == 'granted'
    notification = new Notification('提示', options)
    notification.sound
  else if Notification.permission != 'denied'
    Notification.requestPermission (permission) ->
      if permission == 'granted'
        notification = new Notification('提示', options)
        notification.sound
      return
  return
