
/// A oneliner that follows the world coordinates of an entity
class MP_SU_OnelinerEntity extends MP_SU_Oneliner {
  var entity: CEntity;

  function getPosition(): Vector {
    return this.entity.GetWorldPosition() + this.offset;
  }
}