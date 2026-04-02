import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import "matrix.js" as Matrix

Rectangle {
	id: root
	width: Screen.width
	height: Screen.height
	color: "#020807"

	// SDDM
	property int sessionIndex: sessionSelector.currentIndex
	property alias userName: usernameField.text
	property alias password: passwordField.text

	// Background
	Image {
		id: background
		source: "assets/background.png"
		anchors.fill: parent
		opacity: 0.25
		fillMode: Image.PreserveAspectCrop
	}

	// Matrix
	Canvas {
		id: matrixCanvas
		anchors.fill: parent
		opacity: 0.85

		renderTarget: Canvas.FramebufferObject
		renderStrategy: Canvas.Cooperative

		onPaint: {
			var ctx = getContext("2d");
			Matrix.matrix.drawMatrix(ctx, width, height);
		}

		Timer {
			interval: 40
			running: true
			repeat: true
			onTriggered: matrixCanvas.requestPaint()
		}
	}

	// LOGIN
	ColumnLayout {
		anchors.centerIn: parent
		spacing: 20

		Text {
			text: "Bem-vindo a MATRIX"
			color: "#00ff9c"
			font.pixelSize: 36
			style: Text.Outline
			styleColor: "#003322"
			Layout.alignment: Qt.AlignHCenter
		}

		// USER
		TextField {
			id: usernameField
			placeholderText: "Usuário"
			placeholderTextColor: "#007a5a"
			color: "#00ff9c"
                        selectionColor: "#00cc88"   
			background: Rectangle {
				color: "#03110f"
				border.color: usernameField.activeFocus ? "#00ff9c" : "#004d3a"
				border.width: usernameField.activeFocus ? 2 : 1
				radius: 5
			}

			Layout.alignment: Qt.AlignHCenter
			Layout.preferredWidth: 300
			KeyNavigation.tab: passwordField
		}

		// PASSWORD
		TextField {
			id: passwordField
			placeholderText: "Senha"
			placeholderTextColor: "#007a5a"
			echoMode: TextInput.Password
			color: "#00ff9c"
			selectionColor: "#00cc88" 

			background: Rectangle {
				color: "#03110f"
				border.color: passwordField.activeFocus ? "#00ff9c" : "#004d3a"
				border.width: passwordField.activeFocus ? 2 : 1
				radius: 5
			}

			Layout.alignment: Qt.AlignHCenter
			Layout.preferredWidth: 300
			KeyNavigation.tab: loginButton

			Keys.onPressed: (event) => {
				if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
					loginButton.clicked()
				}
			}
		}

		// BUTTON
		Button {
			id: loginButton
			text: "Conectar"

			background: Rectangle {
				color: parent.pressed ? "#003322" : "#03110f"
				border.color: "#00ff9c"
				border.width: 1
				radius: 5
			}

			contentItem: Text {
				text: "Conectar"
				color: "#00ff9c"
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
			}

			Layout.alignment: Qt.AlignHCenter
			Layout.preferredWidth: 150

			onClicked: {
				sddm.login(usernameField.text, passwordField.text, sessionIndex)
			}
		}
	}

	// SESSION SELECTOR
ComboBox {
    id: sessionSelector
    model: sessionModel
    textRole: "name"
    font.family: "JetBrainsMono Nerd Font Propo"
    font.pixelSize: 14
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.margins: 20
    width: 225

    background: Rectangle {
        color: "#020807"
        border.color: "#00ff9c"
        border.width: 1
        radius: 5
    }

    indicator: Rectangle {
        width: 5
        height: 5
        color: "#00ff9c"  // cor da setinha
        rotation: 45
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        border.color: "#00ff9c"
        border.width: 1
        anchors.rightMargin: 8
    }


    contentItem: Text {
        anchors.fill: parent          // preenche todo o ComboBox
        anchors.margins: 0
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: sessionSelector.displayText
        color: "#00ff9c"
        font.family: "JetBrainsMono Nerd Font Propo"
        font.pixelSize: 14
    }


    popup: Popup {
        y: sessionSelector.height
        width: sessionSelector.width
        implicitHeight: contentItem.implicitHeight
        padding: 1

        background: Rectangle {
            color: "#020807"
            border.color: "#00ff9c"
            border.width: 1
            radius: 5
        }

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: sessionSelector.popup.visible ? sessionSelector.delegateModel : null
            currentIndex: sessionSelector.highlightedIndex

            delegate: ItemDelegate {
              width: sessionSelector.width
              height: 24

    contentItem: Text {
        text: model.name
        color: "#00ff9c"
        font.family: "JetBrainsMono Nerd Font Propo"
        font.pixelSize: 14
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter    // centraliza horizontalmente
        Layout.fillWidth: true                     // faz o Text ocupar a largura do delegate
        elide: Text.ElideRight
    }

    background: Rectangle {
        color: highlighted ? "#003322" : "#020807"
    }
}
        }
    }
}
	// POWER
Row {
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.margins: 20
    spacing: 10

Button {
    width: 40
    height: 40
    background: Rectangle {
        color: parent.pressed ? "#003322" : "#03110f"  // mesma cor do botão Conectar
        border.color: "#00ff9c"
        border.width: 1
        radius: 5
    }
    contentItem: Text {
        text: "⏻"        // ou "↻"
        color: "#00ff9c"
        font.pixelSize: 20
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    onClicked: sddm.powerOff()    // ou sddm.reboot()
}

    Button {
    width: 40
    height: 40
    background: Rectangle {
        color: parent.pressed ? "#003322" : "#03110f"  // mesma cor do botão Conectar
        border.color: "#00ff9c"
        border.width: 1
        radius: 5      
        }
        contentItem: Text {
            text: "↻"
            color: "#00ff9c"
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: sddm.reboot()
    }
}

	// ERROR
	Text {
		id: errorMessage
		anchors.top: parent.top
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.topMargin: 50
		color: "#ff3b3b"
		font.pixelSize: 16
	}

	// AUTO USER
	Instantiator {
		id: userChecker
		model: userModel

		delegate: QtObject {
			property string userName: model.name
			property bool isRoot: model.name === "root"
		}

		property var nonRootUsers: []

		onObjectAdded: function(index, object) {
			if (!object.isRoot) {
				nonRootUsers.push(object.userName)
			}
		}
	}

	Component.onCompleted: {
		Qt.callLater(function() {
			if (userChecker.nonRootUsers.length === 1) {
				usernameField.text = userChecker.nonRootUsers[0]
				passwordField.forceActiveFocus()
			} else {
				usernameField.forceActiveFocus()
			}
		})
	}
}
