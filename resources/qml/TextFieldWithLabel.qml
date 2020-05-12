import QtQuick 2.1
import QtQuick.Controls 2.3

import UM 1.4 as UM
import Cura 1.0 as Cura

Item
{
    id: base
    
    property alias value: textField.text
    property alias text: label.text
    
    height: childrenRect.height
    
    signal editingFinished();

    Label
    {
        id: label
        text: "Sample text"
        anchors
        {
            right: textField.left
            left: parent.left
            verticalCenter: textField.verticalCenter
        }
    }

    Cura.ReadOnlyTextField
    {
        id: textField
        width: (parent.width / 4) | 0
        
        anchors
        {
            right: parent.right
        }
        text: "0"
        
        onEditingFinished:
        {
            base.editingFinished();
        }
    }
}