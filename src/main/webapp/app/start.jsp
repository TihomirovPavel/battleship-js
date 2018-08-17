<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <script src="http://www.w3schools.com/lib/w3data.js"></script>
    <title>Title</title>
</head>
<body onload="checkScores()">
<button type="button" onclick="logout()">Log out</button>
<button type="button" onclick="startGame()">Start Game</button>


<table id="hs-table">
    <tr>
        <td>
            <hi>Highest Scores</hi>
        </td>
    </tr>
    <tr w3-repeat="listHs">
        <td>{{userName}}</td>
        <td>{{bestScore}}</td>
    </tr>

</table>

<script>
    function checkScores() {
        fetch("<c:url value="/api/high-score"/>", {
            "method": "GET",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        }).then(function (response) {
            return response.json();
        }).then(function (highScores) {
            console.log(JSON.stringify(highScores));
            w3DisplayData("hs-table", highScores);
        });
    }

    function logout() {
        fetch("<c:url value='/api/auth/logout'/>", {"method": "POST"})
            .then(function (response) {
                location.href = "/";
            });
    }

    function startGame() {
        fetch("<c:url value='/api/game'/>", {"method": "POST"})
            .then(function (response) {
                location.href = "/app/placement.jsp";
            });
    }
</script>
</body>
</html>
