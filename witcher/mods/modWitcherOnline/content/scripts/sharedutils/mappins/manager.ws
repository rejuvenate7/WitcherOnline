class MP_SU_HashMapValueMapPin extends MP_SU_HashMapValue
{
    public var value : MP_SU_MapPin;
}

function hm_fromMapPin(pin : MP_SU_MapPin) : MP_SU_HashMapValueMapPin
{
    var value : MP_SU_HashMapValueMapPin;

    value = new MP_SU_HashMapValueMapPin in thePlayer;
    value.value = pin;

    return value;
}

function hm_getMapPin(map : MP_SU_HashMap, key : int) : MP_SU_MapPin
{
    var wrapped : MP_SU_HashMapValueMapPin;

    if(!map)
    {
        return NULL;
    }

    wrapped = (MP_SU_HashMapValueMapPin)map.get(key);

    if(wrapped)
    {
        return wrapped.value;
    }

    return NULL;
}

class MP_SUMP_Manager {
  public var mappins: array<MP_SU_MapPin>;
  public var seenPinIds : array<int>;

  public var mappinsByPlayerId : MP_SU_HashMap;

  public function ensurePinIndex()
  {
    if(!this.mappinsByPlayerId)
    {
      this.mappinsByPlayerId = (new MP_SU_HashMap in this).init();
    }
  }

  public function indexPin(pin : MP_SU_MapPin)
  {
    if(!pin)
    {
      return;
    }

    if(pin.playerId <= 0)
    {
      return;
    }

    this.ensurePinIndex();
    this.mappinsByPlayerId.insert(pin.playerId, hm_fromMapPin(pin));
  }

  public function unindexPin(pin : MP_SU_MapPin)
  {
    var current : MP_SU_MapPin;

    if(!pin || !this.mappinsByPlayerId)
    {
      return;
    }

    if(pin.playerId <= 0)
    {
      return;
    }

    current = hm_getMapPin(this.mappinsByPlayerId, pin.playerId);

    if(current == pin)
    {
      this.mappinsByPlayerId.remove(pin.playerId);
    }
  }

  public function getPinByPlayerId(playerId : int) : MP_SU_MapPin
  {
    this.ensurePinIndex();

    if(playerId <= 0)
    {
      return NULL;
    }

    return hm_getMapPin(this.mappinsByPlayerId, playerId);
  }

  public function clearPinIndex()
  {
    this.mappinsByPlayerId = (new MP_SU_HashMap in this).init();
  }
}