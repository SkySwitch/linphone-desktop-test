import QtGraphicalEffects 1.0
import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2

import Common 1.0
import Linphone 1.0

import App.Styles 1.0

// =============================================================================

Window {
  id: window

  // ---------------------------------------------------------------------------

  readonly property bool chatIsOpened: !rightPaned.isClosed()
  readonly property var call: calls.selectedCall
  readonly property var sipAddress: {
    if (call) {
      return call.sipAddress
    }
  }

  // ---------------------------------------------------------------------------

  function openChat () {
    rightPaned.open()
  }

  function closeChat () {
    rightPaned.close()
  }

  // ---------------------------------------------------------------------------

  minimumHeight: CallsWindowStyle.minimumHeight
  minimumWidth: CallsWindowStyle.minimumWidth
  title: CallsWindowStyle.title

  Paned {
    anchors.fill: parent
    defaultChildAWidth: CallsWindowStyle.callsList.defaultWidth
    maximumLeftLimit: CallsWindowStyle.callsList.maximumWidth
    minimumLeftLimit: CallsWindowStyle.callsList.minimumWidth

    // -------------------------------------------------------------------------
    // Calls list.
    // -------------------------------------------------------------------------

    childA: Rectangle {
      anchors.fill: parent
      color: CallsWindowStyle.callsList.color

      ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
          Layout.fillWidth: true
          Layout.preferredHeight: CallsWindowStyle.callsList.header.height

          LinearGradient {
            anchors.fill: parent

            start: Qt.point(0, 0)
            end: Qt.point(0, height)

            gradient: Gradient {
              GradientStop { position: 0.0; color: CallsWindowStyle.callsList.header.color1 }
              GradientStop { position: 1.0; color: CallsWindowStyle.callsList.header.color2 }
            }
          }

          ActionBar {
            anchors {
              left: parent.left
              leftMargin: CallsWindowStyle.callsList.header.leftMargin
              verticalCenter: parent.verticalCenter
            }

            iconSize: CallsWindowStyle.callsList.header.iconSize

            ActionButton {
              icon: 'new_call'
              // TODO: launch new call
            }

            ActionButton {
              icon: 'new_conference'
              // TODO: launch new conference
            }
          }
        }

        Calls {
          id: calls

          Layout.fillHeight: true
          Layout.fillWidth: true

          model: CallsListModel
        }
      }
    }

    // -------------------------------------------------------------------------
    // Content.
    // -------------------------------------------------------------------------

    childB: Paned {
      id: rightPaned

      anchors.fill: parent
      closingEdge: Qt.RightEdge
      defaultClosed: true
      minimumLeftLimit: CallsWindowStyle.call.minimumWidth
      minimumRightLimit: CallsWindowStyle.chat.minimumWidth
      resizeAInPriority: true

      // -----------------------------------------------------------------------

      Component {
        id: incomingCall

        IncomingCall {
          call: window.call
        }
      }

      Component {
        id: outgoingCall

        OutgoingCall {
          call: window.call
        }
      }

      Component {
        id: incall

        Incall {
          call: window.call
        }
      }

      Component {
        id: chat

        Chat {
          proxyModel: ChatProxyModel {
            sipAddress: window.sipAddress
          }
        }
      }

      // -----------------------------------------------------------------------

      childA: Loader {
        active: Boolean(window.call)
        anchors.fill: parent
        sourceComponent: {
          var call = window.call
          if (!call) {
            return null
          }

          var status = call.status
          if (status === CallModel.CallStatusIncoming) {
            return incomingCall
          }

          if (status === CallModel.CallStatusOutgoing) {
            return outgoingCall
          }

          return incall
        }
      }

      childB: Loader {
        active: Boolean(window.sipAddress)
        anchors.fill: parent
        sourceComponent: window.sipAddress ? chat : null
      }
    }
  }
}