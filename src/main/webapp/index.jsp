<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>HAPPY NEW YEAR 2019!</title>
    <style>
        body {
            background-color: skyblue;
        }
        h1 {
            color: darkblue;
            margin-top: 250px;
            font-size: 50px;
            text-align: center;
        }
    </style>
</head>
<body>
<h1 id="messageLabel"></h1>

<script>
var message = "Happy New Year 2019!";
var msgCount = 0;
var blinkCount = 0;
var blinkFlg = 0;
var timer1, timer2;
var messageLabel = document.getElementById("messageLabel");

function textFunc() {

    messageLabel.innerHTML = message.substring(0, msgCount);

    if (msgCount == message.length) {
        // Stop timer
        clearInterval(timer1);

        // Start blinking animation!
        timer2 = setInterval("blinkFunc()", 200);

    } else {
        msgCount++;
    }
}

function blinkFunc() {
    // blink 5 times.
    if (blinkCount < 6) {

        if (blinkFlg == 0) {
            messageLabel.innerHTML = message;
            blinkFlg = 1;
            blinkCount++;

        } else {
            messageLabel.innerHTML = "";
            blinkFlg = 0;
        }

    } else {
        // Stop timer
        clearInterval(timer2);
    }
}
timer1 = setInterval("textFunc()", 150); // every 150 milliseconds
</script>
<p> “I hope that in this year to come, you make mistakes.<br/>

Because if you are making mistakes, then you are making new things, trying new things, learning, living, pushing yourself, changing yourself, changing your world. You’re doing things you’ve never done before, and more importantly, you’re doing something”.<br/>

― Neil Gaiman <br/> </p>


<p>
	<div> Everyday is a new opportunity to have a fresh start </div> <br/>
	Note:The website is still developing any may down for maintenance.</p>
</body>
</html>
