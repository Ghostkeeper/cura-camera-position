import QtQuick 2.10
import QtQuick.Controls 2.3

import UM 1.4 as UM
import Cura 1.0 as Cura

import ActualCameraPosition 1.0

Item
{
    ActualCameraPosition
    {
        id: cameraPosition
        objectName: "cameraPosition"
    }
    
    UM.Dialog
    {
        id: dialog
    
        title: "Camera Position"
        width: UM.Theme.getSize("setting").width
        height: contents.height
    
        Column
        {
            id: contents
            padding: UM.Theme.getSize("thick_margin").width
            spacing: UM.Theme.getSize("thin_margin").width
            width: parent.width
    
            TextFieldWithLabel
            {
                id: xTranslateField
                anchors
                {
                    left: parent.left
                    right: parent.right
                    margins: parent.padding
                }
                text: "X camera position"
            }
    
            TextFieldWithLabel
            {
                id: yTranslateField
                anchors
                {
                    left: parent.left
                    right: parent.right
                    margins: parent.padding
                }
                text: "Y camera position"
            }
    
            TextFieldWithLabel
            {
                id: zTranslateField
                anchors
                {
                    left: parent.left
                    right: parent.right
                    margins: parent.padding
                }
                text: "Z camera position"
            }
    
            TextFieldWithLabel
            {
                id: xLookAtField
                anchors
                {
                    left: parent.left
                    right: parent.right
                    margins: parent.padding
                }
                text: "X look at position"
            }
    
            TextFieldWithLabel
            {
                id: yLookAtField
                anchors
                {
                    left: parent.left
                    right: parent.right
                    margins: parent.padding
                }
                text: "Y look at position"
            }
    
            TextFieldWithLabel
            {
                id: zLookAtField
                anchors
                {
                    left: parent.left
                    right: parent.right
                    margins: parent.padding
                }
                text: "Z look at position"
            }
    
            TextFieldWithLabel
            {
                id: zoomFactor
                anchors
                {
                    left: parent.left
                    right: parent.right
                    margins: parent.padding
                }
                text: "Camera zoom factor (Orthographic)"
                validator: DoubleValidator
                {
                    bottom: -0.4999999999
                }
            }
    
            Cura.PrimaryButton
            {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Set camera position"
                enabled: xTranslateField.value != "" && yTranslateField.value != "" && zTranslateField.value != "" &&
                        xLookAtField.value != "" && yLookAtField.value != "" && zLookAtField.value != "" && zoomFactor != ""
                onClicked:
                {
                    UM.Controller.setCameraPosition(xTranslateField.value, zTranslateField.value, yTranslateField.value)
                    UM.Controller.setLookAtPosition(xLookAtField.value, zLookAtField.value, yLookAtField.value)
                    UM.Controller.setCameraZoomFactor(zoomFactor.value)
                }
            }
        }
    }

}
