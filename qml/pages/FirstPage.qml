import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.0


Page {
    id: page
    allowedOrientations: Orientation.All

    property real number: 0
    function answer() {
        var answers = ["It is certain.", "It is decidedly so.", "Without a doubt.", "Yes — definitely.", "You may rely on it.",
                "As I see it, yes.", "Most likely.", "Outlook good.", "Signs point to yes.", "Yes.",
                "Reply hazy, try again.", "Ask again later.", "Better not tell you now.", "Cannot predict now.", "Concentrate and ask again.",
                "Don’t count on it.", "My reply is no.", "My sources say no.", "Outlook not so good.", "Very doubtful."];

        number = Math.ceil(shakeSensor.random * 1000) % 20;
        return answers [number];
    }

    function buttonAnswer() {
        var answers = ["It is certain.", "It is decidedly so.", "Without a doubt.", "Yes — definitely.", "You may rely on it.",
                "As I see it, yes.", "Most likely.", "Outlook good.", "Signs point to yes.", "Yes.",
                "Reply hazy, try again.", "Ask again later.", "Better not tell you now.", "Cannot predict now.", "Concentrate and ask again.",
                "Don’t count on it.", "My reply is no.", "My sources say no.", "Outlook not so good.", "Very doubtful."];

        number =  Math.ceil(Math.random() * 20);
        return answers [number];
    }

    function getRandomInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    function randEmoji(number) {
        if (number >= 0 && number <= 9)
            return getRandomInt(0, 2);
        else
            if (number >= 10 && number <= 14)
                return getRandomInt(3, 5);
            else
                if (number >= 15 && number <= 19)
                    return getRandomInt(6, 7);
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Chance.")
            }

            Text {
                id: output
                width: parent.width
                horizontalAlignment: Text.Center
                color: Theme.secondaryColor
                font.bold: true
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraLarge
                EnterKey.onClicked: answer();
                //EnterKey.onClicked: buttonAnswer();
            }

            Button {
                id: convertButton
                text: qsTr("Go")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    output.text = buttonAnswer();
                }
            }

            Label {
                id: label
                text: qsTr("Click or shake!")
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeExtraSmall
            }

            Image {
                    id: emoji
                    source: "../emojis/emoji-" + randEmoji(number) + ".png"
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    height: sourceSize.height * width / sourceSize.width
            }
        }
    }

    ShakeSensor {
        id: shakeSensor

        property real random: 0
        property real count: 0

        active: true

        onShaked: {
            // console.log("-- -- -- x:" + reading.x + ";\t y: " + reading.y + ";\t z: "+ reading.z);
            if (count == 0) {
                output.text = "";
            }

            count += 1;
            random += Math.abs(reading.x) + Math.abs(reading.y) + Math.abs(reading.y);
            if (random > 1000) {
                random -= 1000;
            }
            shakeTimeout.restart();
        }
    }
    Timer {
        id: shakeTimeout
        interval: 600 //1200
        repeat: false
        onTriggered: {
            // console.log("answer", shakeSensor.count, shakeSensor.random);
            if (shakeSensor.count >= 2) {
                output.text = answer();
            }
            shakeSensor.count = 0;
        }
    }

}
