<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <title>Game</title>
</head>
<body onload="checkStatus()">
<div id="wait-another" class="w3-hide">
    <h1 id="note">Please wait for opponent to finish his move</h1>
</div>

<div id="player-field">
    <table>
        <tr>
            <td>&nbsp;</td>
            <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                <td><c:out value="${col}"/></td>
            </c:forTokens>
        </tr>
        <c:forTokens items="1,2,3,4,5,6,7,8,9,10" delims="," var="row">
            <tr>
                <td><c:out value="${row}"/></td>
                <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                    <td></td>
                </c:forTokens>
            </tr>
        </c:forTokens>
    </table>
</div>


<div id="opponent-field">
    <table>
        <tr>
            <td>&nbsp;</td>
            <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                <td><c:out value="${col}"/></td>
            </c:forTokens>
        </tr>
        <c:forTokens items="1,2,3,4,5,6,7,8,9,10" delims="," var="row">
            <tr>
                <td><c:out value="${row}"/></td>
                <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                    <td><input type="checkbox" id="${col}${row}"/></td>
                </c:forTokens>
            </tr>
        </c:forTokens>
    </table>
    <button id="fire" type="button" onclick="fire()">Fire!</button>
</div>

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
            if (game.status === "STARTED" && game.playerActive) {
                location.href = "<c:url value='/app/game.jsp'/>";
            } else if (game.status === "PLACEMENT" && game.playerActive) {
                document.getElementById("fire").classList.remove("w3-hide");
                document.getElementById("note").classList.add("w3-hide");
            } else {
                document.getElementById("fire").classList.add("w3-hide");
                document.getElementById("note").classList.remove("w3-hide");
                window.setTimeout(function () {
                    checkStatus();
                }, 1000);
            }
        });
    }

    function fire() {
        console.log("sending fire");
        fetch("<c:url value='/api/game/fire'/>", {
            "method": "POST",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        }).then(function (response) {
            console.log("TODO FIRE");
            checkStatus();
        });
    }
</script>

</body>
</html>