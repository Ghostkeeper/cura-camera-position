import os

from PyQt5.QtCore import QObject
from PyQt5.QtQml import qmlRegisterType
from UM.Extension import Extension
from UM.Logger import Logger
from UM.PluginRegistry import PluginRegistry
from UM.i18n import i18nCatalog

from cura.CuraApplication import CuraApplication
from .ActualCameraPosition import ActualCameraPosition

i18n_catalog = i18nCatalog("cura")


class CameraPositionExtension(QObject, Extension):

    def __init__(self, parent=None) -> None:
        QObject.__init__(self, parent)
        Extension.__init__(self)

        self._view = None
        self._camPos: ActualCameraPosition = None

        # Build the camera menu
        self.setMenuName("Camera Position")
        self.addMenuItem("Camera controller", self.showPopup)

        CuraApplication.getInstance().mainWindowChanged.connect(self._createView)

    def showPopup(self) -> None:
        if self._view is None:
            self._createView()
            if self._view is None:
                Logger.log("e", "Not creating Camera Position window since the QML component failed to be created.")
                return
        self._view.show()

    def _createView(self) -> None:
        Logger.log("d", "Creating Camera Position plugin view.")

        qmlRegisterType(ActualCameraPosition, 'ActualCameraPosition', 1, 0, 'ActualCameraPosition')
        plugin_path = PluginRegistry.getInstance().getPluginPath(self.getPluginId())
        path = os.path.join(plugin_path, "resources", "qml", "CameraPositionPanel.qml")
        self._view = CuraApplication.getInstance().createQmlComponent(path, {"manager": self})
        self._camPos: ActualCameraPosition = self._view.findChild(ActualCameraPosition, "cameraPosition")
        self._camPos.setController(CuraApplication.getInstance().getController())
