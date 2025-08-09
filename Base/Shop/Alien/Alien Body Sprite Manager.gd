extends Timer
class_name AlienBodySpriteManager

### This script adds more body sprite that Aliens can have as time passes
### The reason is, body sprite affects the Alien's wait time
### We want body sprite with short wait time to appear later in the game

# Body sprites that can spawn in shop queue
var bodySprites: Array[Texture2D] = [];

# Key = Body sprite path, value = wait time (sec)
var waitTimeBasedOnBodySprite: Dictionary = { };
func _UnlockBodySprites(inWaitTimeBasedOnBodySpriteDict: Dictionary):
	self.waitTimeBasedOnBodySprite.merge(inWaitTimeBasedOnBodySpriteDict);
	
	inWaitTimeBasedOnBodySpriteDict.keys().map(
		func (inBodySpritePath: String):
			self.bodySprites.append(load(inBodySpritePath) as Texture2D);
	)

# Key = Minutes that must pass to unlock value (measured from start of game), value = waitTimeBasedOnBodySprite Dictionary
var _bodySpriteUnlockStages: Dictionary = {
	5: {
		"res://Base/Shop/Alien/Sprite/Body/Body3.png": 7,
		"res://Base/Shop/Alien/Sprite/Body/Body4.png": 8,
		"res://Base/Shop/Alien/Sprite/Body/Body6.png": 9,
	},
	10: {
		"res://Base/Shop/Alien/Sprite/Body/Body8.png": 3,
		"res://Base/Shop/Alien/Sprite/Body/Body9.png": 2,
	},
}
var _unlockStage: int = 0;	# Which index to unlock of the above Dictionary

func _ready():
	self._UnlockBodySprites({
		"res://Base/Shop/Alien/Sprite/Body/Body1.png": 10,
		"res://Base/Shop/Alien/Sprite/Body/Body2.png": 12,
		"res://Base/Shop/Alien/Sprite/Body/Body5.png": 11,
		"res://Base/Shop/Alien/Sprite/Body/Body7.png": 10,
	});
	
	self.wait_time = self._bodySpriteUnlockStages.keys()[self._unlockStage] * 60;
	self.timeout.connect(
		func ():
			self._UnlockBodySprites(self._bodySpriteUnlockStages.values()[self._unlockStage]);
			
			self._unlockStage += 1;
			if (self._unlockStage >= self._bodySpriteUnlockStages.size()):
				self.stop();
				return;
			
			var prevStagesWaitTime: float = 0;
			for i in self._unlockStage:
				prevStagesWaitTime += self._bodySpriteUnlockStages.keys()[i];
			self.wait_time = self._bodySpriteUnlockStages.keys()[self._unlockStage] - prevStagesWaitTime;
	)
	self.start();
