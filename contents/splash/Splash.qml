import QtQuick

Rectangle {
    id: root
    color: "#050505"

    // KSplashQML updates this property as Plasma starts.
    property int stage: 0
    readonly property color red: "#fb394a"
    readonly property color dimRed: "#7d202b"
    readonly property real progress: stage <= 0 ? 0
                                   : stage === 1 ? 0.12
                                   : stage === 2 ? 0.30
                                   : stage === 3 ? 0.52
                                   : stage === 4 ? 0.76 : 1
    readonly property bool compact: width < 700 || height < 500

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "#0b0507" }
            GradientStop { position: 0.55; color: "#050505" }
            GradientStop { position: 1; color: "#0b0507" }
        }
    }

    // Quiet framing details stay near the edges at every screen size.
    Rectangle {
        x: 0; y: 0; width: parent.width; height: 2
        color: root.red; opacity: 0.75
    }
    Rectangle {
        x: 0; y: parent.height - 2; width: parent.width; height: 2
        color: root.red; opacity: 0.35
    }
    Rectangle {
        x: root.compact ? 20 : 48; y: root.compact ? 24 : 48
        width: root.compact ? 24 : 38; height: 2; color: root.red
    }
    Rectangle {
        x: root.compact ? 20 : 48; y: root.compact ? 24 : 48
        width: 2; height: root.compact ? 24 : 38; color: root.red
    }
    Rectangle {
        x: parent.width - (root.compact ? 44 : 86)
        y: parent.height - (root.compact ? 26 : 50)
        width: root.compact ? 24 : 38; height: 2; color: root.red
    }
    Rectangle {
        x: parent.width - (root.compact ? 22 : 50)
        y: parent.height - (root.compact ? 48 : 86)
        width: 2; height: root.compact ? 24 : 38; color: root.red
    }

    Image {
        id: wordmark
        anchors.horizontalCenter: parent.horizontalCenter
        y: -root.height * 0.03
        width: Math.min(root.width * 0.78, 700)
        height: width / 3
        source: "images/logo-red.png"
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        smooth: false
    }

    Item {
        id: centerpiece
        width: Math.min(root.width * 0.8, root.height * (root.height < 450 ? 0.45 : 0.59), 600)
        height: width
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height * 0.49 - height / 2

        Rectangle {
            width: parent.width * 0.9
            height: width
            radius: width / 2
            anchors.centerIn: parent
            color: "transparent"
            border.color: "#442027"
            border.width: 1
            opacity: 0.75
            RotationAnimation on rotation {
                from: 0; to: 360; duration: 30000
                loops: Animation.Infinite
                running: true
            }
            Rectangle {
                width: 5; height: 5; radius: 3
                x: parent.width / 2 - 2; y: -2
                color: root.red
            }
        }

        Image {
            anchors.fill: parent
            source: "images/marvin-lightsaber.png"
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            smooth: true
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: centerpiece.y + centerpiece.height + 1
        text: "✦  BENVENUTO NEL MULTIVERSO  ✦"
        color: root.red
        opacity: 0.82
        font.family: "monospace"
        font.pixelSize: root.compact ? 10 : 13
        font.bold: true
        font.letterSpacing: root.compact ? 1 : 3
    }

    Item {
        id: loader
        width: Math.min(root.width - (root.compact ? 48 : 100), 580)
        height: 98
        anchors.horizontalCenter: parent.horizontalCenter
        y: Math.min(root.height - 90, root.height * 0.835)

        Text {
            id: statusText
            anchors.left: parent.left
            anchors.top: parent.top
            text: root.stage >= 5 ? "PRONTO" : "CARICAMENTO PLASMA"
            color: root.red
            font.family: "monospace"
            font.pixelSize: root.compact ? 10 : 12
            font.bold: true
            font.letterSpacing: 2
        }
        Text {
            anchors.right: parent.right
            anchors.top: parent.top
            text: Math.round(root.progress * 100) + "%"
            color: root.red
            font.family: "monospace"
            font.pixelSize: root.compact ? 10 : 12
            font.bold: true
        }

        Rectangle {
            id: rail
            x: 0; y: 30; width: parent.width; height: 12
            radius: 2
            color: "#220b0e"
            border.color: root.dimRed
            border.width: 1
            clip: true

            Rectangle {
                id: fill
                x: 1; y: 1
                width: Math.max(0, (rail.width - 2) * root.progress)
                height: rail.height - 2
                radius: 1
                color: root.red
                Behavior on width {
                    NumberAnimation { duration: 650; easing.type: Easing.OutCubic }
                }

                Rectangle {
                    anchors.fill: parent
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0; color: "#b91f32" }
                        GradientStop { position: 0.65; color: root.red }
                        GradientStop { position: 1; color: "#ff7580" }
                    }
                }
                Rectangle {
                    width: 60; height: parent.height
                    x: -width
                    opacity: 0.65
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0; color: "transparent" }
                        GradientStop { position: 0.5; color: "#fff0d8" }
                        GradientStop { position: 1; color: "transparent" }
                    }
                    SequentialAnimation on x {
                        loops: Animation.Infinite
                        running: fill.width > 60 && root.stage < 5
                        NumberAnimation { from: -60; to: fill.width + 60; duration: 1700 }
                        PauseAnimation { duration: 350 }
                    }
                }
            }

            Repeater {
                model: 24
                Rectangle {
                    x: (index + 1) * rail.width / 25
                    y: 1; width: 1; height: rail.height - 2
                    color: "#050505"
                    opacity: 0.35
                }
            }
        }

        Rectangle {
            x: Math.max(0, Math.min(rail.width - 8, rail.width * root.progress - 4))
            y: 26; width: 8; height: 20
            radius: 2; color: root.red
            visible: root.progress > 0
            opacity: 0.35
            Behavior on x {
                NumberAnimation { duration: 650; easing.type: Easing.OutCubic }
            }
        }

        Text {
            anchors.left: parent.left
            y: 58
            text: "◆  " + (root.stage >= 5 ? "IL DESKTOP È PRONTO" : "LA MAGIA STA ARRIVANDO")
            color: "#a64a55"
            font.family: "monospace"
            font.pixelSize: root.compact ? 9 : 11
            font.letterSpacing: 1
        }
    }
}
