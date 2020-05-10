from PyQt5.QtCore import QObject, pyqtProperty
from UM.Controller import Controller
from UM.Math.Vector import Vector


class ActualCameraPosition(QObject):
    """A qml enable python class which exposes the position and orientation of the camera in Euler space
    
    Example:
        .. code-block::
        
           controller = CuraApplication.getInstance().getController()
           instance = ActualCameraPosition(controller)
           x = instance.position_x  # get the x position of the camera origin
           instance.position_y  # set the y position of the camera origin
           alpha = instance.orientation_x  # get the rotation along the x axis
           instance.orientation_z = 45  # rotate the camera along the z axis to 45 degree
    """

    def __init__(self, parent=None):
        super(ActualCameraPosition, self).__init__(parent)
        self._controller: Controller = None  # https://stackoverflow.com/questions/57153525/how-to-pass-init-arguments-to-class-registered-with-qmlregistertype
        self._comp = {'x', 'y', 'z'}
        
        # Create the PyQtProperties dynamically for each axis
        # Todo: check if I need to disable these get/set until the controller is set
        for comp in self._comp:
            # Create pyqtproperties for position_x, position_y and position_z
            setattr(self, "position_{}".format(comp),
                    pyqtProperty(float, getattr(self._controller.getCameraPosition(), comp),
                                 lambda p: self._setPosition(**{comp: p})))
            # Create pyqtproperties for orientation_x, orientation_y and orientation_z
            setattr(self, "orientation_{}",
                    pyqtProperty(float, getattr(self._controller.getCameraOrientation().toMatrix().getEuler(), comp),
                                 lambda o: self._setPosition(**{comp: o})))
            
    def setController(self, controller: Controller):
        self._controller = controller

    def _setPosition(self, **kwargs):
        """Sets an arbitrary number of component from the camera controller position vector
        
        Example:
        .. code-block::
        
            instance._setPostion(x=2)
            # or
            instance._setPosition(x=2, z=4)
               
        :param kwargs: the component to be set, either x, y or z
        """

        static_kws = set(kwargs.keys()).difference(
            self._comp)  # Obtain the position component name which aren't changed
        static_args = [getattr(self._controller.getCameraPosition(), kw) for kw in
                       static_kws]  # Obtain the values of these unchanged positions
        static_kws = ["{}_position".format(kw) for kw in
                      static_kws]  # Convert the keywords to the names used by setCameraPosition
        static_kwargs = dict(
            zip(static_kws, static_args))  # Create a kwargs dictionary with the previously obtained values
        for kw, arg in static_kwargs.items():
            static_kwargs["{}_position".format(kw)] = arg  # add the user changed value to the kwargs
        self._controller.setCameraPosition(**static_kwargs)  # call the setCameraPosition which takes care of the rest

    def _setOrientation(self, **kwargs):
        """Sets an arbitrary number of rotations along axes given in Euler space and degrees
        
        Example:
        
        .. code-block::
        
            instance._setOrientation(x=45)
            # or
            instance._setOrientation(x=22, z=45)
            
        :param kwargs:
        """
        
        # TODO: don't modify actual but make it absolute
        actual = self._controller.getCameraOrientation()  # Obtain the actual transformation
        for kw, arg in kwargs.items():
            axis = Vector(**{kw: 1})  # build the vector where the axis of rotation is set to 1
            rot_kwargs = {
                kw: arg,
                'axis': axis
            }  # build setByAngleAxis kwargs
            actual.setByAngleAxis(**rot_kwargs)  # transform the camera orientation
        self._controller.setCameraOrientation(actual)  # update the new orientation to the camera
