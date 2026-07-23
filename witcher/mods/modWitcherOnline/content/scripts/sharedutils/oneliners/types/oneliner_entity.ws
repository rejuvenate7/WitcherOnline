
/// A oneliner that follows the world coordinates of an entity
class MP_SU_OnelinerEntity extends MP_SU_Oneliner {
  var entity: CEntity;
  var head : bool;

  function getPosition(): Vector {

    if(head)
    {
      return this.entity.GetBoneWorldPosition('head') + Vector(0, 0, 0.35);
    }
    else
    {
      return this.entity.GetWorldPosition() + this.offset;
    }
  }
}