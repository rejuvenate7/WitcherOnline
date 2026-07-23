// Witcher Online by rejuvenate
// https://www.nexusmods.com/profile/rejuvenate7
statemachine class MPDRPlayer extends CNewNPC
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{	
		super.OnSpawned( spawnData );

		((CActor)this).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CActor)this).EnableCollisions(false);
		((CActor)this).EnableCharacterCollisions(false);

		this.SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	
	}

	event OnDeath( damageAction : W3DamageAction  )
	{

	}

	event OnDestroyed()
	{
		
	}

	event OnInteraction(actionName: string, activator: CEntity) 
	{
		if (activator != thePlayer) 
		{
			return false;
		}

		if( actionName == "Interact" )
		{
			theGame.r_getMultiplayerClient().createMenu(((CActor)this));
		}
	}
	
	event OnInteractionActivationTest(interactionComponentName: string, activator: CEntity) 
	{
		if( interactionComponentName == "wo_interact" )
		{
			if( activator == thePlayer && !theGame.r_getMultiplayerClient().isRiding())
			{	
				return true;
			}
		}
		else
		{
			return false;
		}

		return false;
	}
}