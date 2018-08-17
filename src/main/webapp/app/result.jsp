<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <title>Results</title>
</head>
<body onload="checkStatus()">

<div id="win" class="w3-hide">
    <h1>You Have WON!!</h1>
</div>
<div id="loss" class="w3-hide">
    <h1>Yoy have LOST</h1>
</div>

<button id="new-game" type="button" onclick="startGame()">New Game</button>
<button id="return-main" type="button" onclick="redirectToMain()">Return</button>

<script>

    function checkStatus() {
        console.log("checking status");
        fetch("<c:url value='/api/game/status'/>", {
            "method": "GET",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        }).then(function (response) {
            return response.json();
        }).then(function (game) {
            console.log(JSON.stringify(game));
            if (game.status === "FINISHED" && game.playerActive) {
                document.getElementById("win").classList.remove("w3-hide");
                document.getElementById("loss").classList.add("w3-hide");
                saveScore()
            } else if (game.status === "FINISHED" && !game.playerActive) {
                document.getElementById("win").classList.add("w3-hide");
                document.getElementById("loss").classList.remove("w3-hide");
            } else {
                document.getElementById("win").classList.add("w3-hide");
                document.getElementById("loss").classList.add("w3-hide");
            }
        });
    }
    function saveScore() {
        fetch("<c:url value='/api/high-score'/>", {
            "method": "POST",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        }).then(function (response) {
            console.log("DONE");
        })
    };

    function startGame() {
        fetch("<c:url value='/api/game'/>", {"method": "POST"})
            .then(function (response) {
                location.href = "/app/placement.jsp";
            });
    }

    function redirectToMain() {
        location.href = "<c:url value="start.jsp"/>"
    };

</script>

</body>
</html>
