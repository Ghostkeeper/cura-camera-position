import QtQuick 2.10
import QtQuick.Controls 2.3

import UM 1.4 as UM
import Cura 1.0 as Cura

UM.Dialog
{
    id: dialog

    title: "Camera Position"
    minimumWidth: 280 * screenScaleFactor
    minimumHeight: 280 * screenScaleFactor
    width: 280 * screenScaleFactor
    height: contents.height

    onVisibleChanged:
    {
        updateGUIvalues()
    }
    
    function rad2deg(rad)
    {
        return rad * 57.2957795;
    }
    
    function deg2rad(deg)
    {
        return deg / 57.2957795;
    }
    
    function updatePosition()
    {
        UM.Controller.setCameraPosition(xTranslateField.value, zTranslateField.value, yTranslateField.value);
    }
    
    function updateAngle()
    {
        UM.Controller.setCameraOrientation(deg2rad(xOrientation.value), deg2rad(zOrientation.value), deg2rad(yOrientation.value))
    }
    
    function updateGUIvalues()
    {
        xTranslateField.value = UM.Controller.getCameraPosition("x").toFixed(0);
        yTranslateField.value = UM.Controller.getCameraPosition("z").toFixed(0);
        zTranslateField.value = UM.Controller.getCameraPosition("y").toFixed(0);
        xOrientation.value = rad2deg(UM.Controller.getCameraOrientation("x")).toFixed(2);
        yOrientation.value = rad2deg(UM.Controller.getCameraOrientation("z")).toFixed(2);
        zOrientation.value = rad2deg(UM.Controller.getCameraOrientation("y")).toFixed(2);
        zoomFactor.visible = !UM.Controller.isCameraPerspective;
    }
    
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
            value: UM.Controller.getCameraPosition("x").toFixed(0)
            onEditingFinished:
            {
                dialog.updatePosition();
                dialog.updateGUIvalues();
            }
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
            value: UM.Controller.getCameraPosition("z").toFixed(0)
            onEditingFinished:
            {
                dialog.updatePosition();
                dialog.updateGUIvalues();
            }
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
            value: UM.Controller.getCameraPosition("y").toFixed(0)
            onEditingFinished:
            {
                dialog.updatePosition();
                dialog.updateGUIvalues();
            }
        }

        TextFieldWithLabel
        {
            id: xOrientation
            anchors
            {
                left: parent.left
                right: parent.right
                margins: parent.padding
            }
            text: "Rotation along the X-axis"
            value: {dialog.rad2deg(UM.Controller.getCameraOrientation("x")).toFixed(2)}
            onEditingFinished:
            {
                dialog.updateAngle();
                dialog.updateGUIvalues();
            }
        }

        TextFieldWithLabel
        {
            id: yOrientation
            anchors
            {
                left: parent.left
                right: parent.right
                margins: parent.padding
            }
            text: "Rotation along the Y-axis"
            value: dialog.rad2deg(UM.Controller.getCameraOrientation("z")).toFixed(2);
            onEditingFinished:
            {
                dialog.updateAngle();
                dialog.updateGUIvalues();
            }
        }

        TextFieldWithLabel
        {
            id: zOrientation
            anchors
            {
                left: parent.left
                right: parent.right
                margins: parent.padding
            }
            text: "Rotation along the Z-axis"
            value: dialog.rad2deg(UM.Controller.getCameraOrientation("y")).toFixed(2);
            onEditingFinished:
            {
                dialog.updateAngle();
                dialog.updateGUIvalues();
            }
        }

        TextFieldWithLabel
        {
            id: zoomFactor
            visible: !UM.Controller.isCameraPerspective;
            anchors
            {
                left: parent.left
                right: parent.right
                margins: parent.padding
            }
            text: "Camera zoom factor (Orthographic)"
        }

        Cura.PrimaryButton
        {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Set camera position"
            enabled: xTranslateField.value != "" && yTranslateField.value != "" && zTranslateField.value != "" &&
                    xOrientation.value != "" && yOrientation.value != "" && xOrientation.value != "" && zoomFactor != ""
            onClicked:
            {
                dialog.updatePosition()
                dialog.updateAngle()
                UM.Controller.setCameraZoomFactor(zoomFactor.value)
                dialog.close()
            }
        }
    }
}
