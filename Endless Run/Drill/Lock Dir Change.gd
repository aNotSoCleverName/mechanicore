extends Timer

var _isLockDirChange: bool = false:
	get:
		return _isLockDirChange;
	set(inValue):
		_isLockDirChange = inValue;

func StartTimer():
	self._isLockDirChange = true;
	self.start();

func _timeout():
	self._isLockDirChange = false;
