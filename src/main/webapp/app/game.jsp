<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <title>Game</title>
    <style>
        table {
            border-collapse: collapse;
        }

        table, th, td {
            border: 1px solid black;
        }

        td {
            width: 20px;
            text-align: center;
        }

        td.SHIP {
            background-color: black;
        }

        td.MISS {
            background-color: aqua;
        }

        td.HIT {
            background-color: red;
        }
    </style>
</head>
<body onload="checkStatus()">
<div id="wait-another" class="w3-hide">
    <h1>Please wait for opponent to finish his move</h1>
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
                    <td id="m${col}${row}">&nbsp;</td>
                </c:forTokens>
            </tr>
        </c:forTokens>
    </table>
</div>


<div id="opponent-field" style="alignment: left">
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
                    <td id="t${col}${row}"><input type="radio" name="cells" id="${col}${row}"/></td>
                </c:forTokens>
            </tr>
        </c:forTokens>
    </table>
    <button id="fire" type="button" onclick="fire()">Fire!</button>
</div>

<script>
    function drawInFields() {
        fetch("<c:url value="/api/game/cells"/>", {
            "method": "GET",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        }).then(function (response) {
            return response.json();
        }).then(function (cells) {
            console.log(JSON.stringify(cells))
            cells.forEach(function (c) {
                var id = (c.targetArea ? "t" : "m") + c.address;
                var tblCell = document.getElementById(id);
                tblCell.className = c.state;
            });
        });
    }

    function radioBtnActivity(isActive) {
        var radioBtn = document.querySelectorAll('input[name=cells]');
        radioBtn.forEach(
            function (btn) {
                if (isActive) {
                    btn.classList.remove("w3-hide")
                } else {
                    btn.classList.add("w3-hide")
                }
            }
        )
    }


    function checkStatus() {
        fetch("<c:url value='/api/game/status'/>", {
            "method": "GET",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        }).then(function (response) {
            return response.json();
        }).then(function (gameDto) {
            drawInFields();
            console.log(JSON.stringify(gameDto));
            if (gameDto.status === "STARTED" && gameDto.playerActive) {
                document.getElementById("fire").classList.remove("w3-hide");
                document.getElementById("wait-another").classList.add("w3-hide");
                radioBtnActivity(gameDto.playerActive);
            } else if (gameDto.status === "STARTED" && !gameDto.playerActive) {
                document.getElementById("fire").classList.add("w3-hide");
                document.getElementById("wait-another").classList.remove("w3-hide");
                radioBtnActivity(gameDto.playerActive);

                window.setTimeout(function () {
                    checkStatus();
                }, 1000);
            } else if (gameDto.status == "FINISHED") {
                console.log("should finish");
                //TODO
            } else {
                return;
            }
            drawInFields();
        });
    }

    function fire() {
        console.log("fire");
        var checked = document.querySelector('input[name=cells]:checked');
        var checkedAddress = checked.id;
        console.log(checkedAddress);
        var url = "/api/game/fire/" + checkedAddress;
        fetch("<c:url value='/api/game/fire'/>/" + checkedAddress, {
            "method": "POST",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(checkedAddress)
        }).then(function (response) {
            checkStatus();
        });
    }

</script>

</body>
</html>