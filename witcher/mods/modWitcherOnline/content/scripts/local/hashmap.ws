class MP_SU_HashMap {
  public var buckets: array<MP_SU_HashMapBucket>;

  public var buckets_count: int;

  public var items_count: int;

  public function init(): MP_SU_HashMap {
    var i: int;

    this.buckets.Clear();
    this.buckets.Grow(29);

    this.buckets_count = this.buckets.Size();
    this.items_count = 0;

    for (i = 0; i < this.buckets_count; i += 1) {
      this.buckets[i] = new MP_SU_HashMapBucket in this;
    }

    return this;
  }

  public function insert(key: int, value: MP_SU_HashMapValue) {
    if (this.insertNoResize(key, value)) {
      if (this.getLoadFactor() > 0.9) {
        this.allocateNewBuckets();
      }
    }
  }

  private function insertNoResize(key: int, value: MP_SU_HashMapValue): bool {
    var bucket: MP_SU_HashMapBucket;
    var hash: int;
    var item: MP_SU_HashMapBucketItem;

    hash = this.getHash(key);
    bucket = this.buckets[hash];

    item.key = key;
    item.value = value;

    if (bucket.insert(item)) {
      this.items_count += 1;
      return true;
    }

    return false;
  }

  public function get(key: int): MP_SU_HashMapValue {
    var bucket: MP_SU_HashMapBucket;
    var hash: int;
    var value: MP_SU_HashMapValue;

    hash = this.getHash(key);
    bucket = this.buckets[hash];

    if (bucket.get(key, value)) {
      return value;
    }

    return NULL;
  }

  public function remove(key: int): bool {
    var bucket: MP_SU_HashMapBucket;
    var hash: int;

    hash = this.getHash(key);
    bucket = this.buckets[hash];

    if (bucket.remove(key)) {
      this.items_count -= 1;
      return true;
    }

    return false;
  }

  private function getHash(key: int): int {
    var hash: int;

    if (this.buckets_count <= 0) {
        return 0;
    }

    hash = (int)ModF(key, this.buckets_count);

    if (hash < 0) {
        hash += this.buckets_count;
    }

    return hash;
  }

  private function getLoadFactor(): float {
    if (this.buckets_count <= 0) {
      return 0.0;
    }

    return (float)this.items_count / (float)this.buckets_count;
  }

  private function allocateNewBuckets() {
    var all_items: array<MP_SU_HashMapBucketItem>;
    var current_item: MP_SU_HashMapBucketItem;
    var old_buckets_count: int;
    var new_buckets_count: int;
    var i: int;

    old_buckets_count = this.buckets_count;

    for (i = 0; i < old_buckets_count; i += 1) {
      this.buckets[i].extractValues(all_items);
    }

    new_buckets_count = MP_SU_getNextPrimeNumber(old_buckets_count);

    this.buckets.Grow(new_buckets_count - old_buckets_count);
    this.buckets_count = this.buckets.Size();

    for (i = old_buckets_count; i < this.buckets_count; i += 1) {
      this.buckets[i] = new MP_SU_HashMapBucket in this;
    }

    this.items_count = 0;

    for (i = 0; i < all_items.Size(); i += 1) {
      current_item = all_items[i];
      this.insertNoResize(current_item.key, current_item.value);
    }
  }
}

struct MP_SU_HashMapBucketItem {
  var key: int;
  var value: MP_SU_HashMapValue;
}

class MP_SU_HashMapBucket {
  public var items: array<MP_SU_HashMapBucketItem>;

  public function insert(value: MP_SU_HashMapBucketItem): bool {
    var i: int;

    for (i = 0; i < this.items.Size(); i += 1) {
      if (this.items[i].key == value.key) {
        this.items[i] = value;
        return false;
      }
    }

    this.items.PushBack(value);

    return true;
  }

  public function get(key: int, out value: MP_SU_HashMapValue): bool {
    var i: int;

    for (i = 0; i < this.items.Size(); i += 1) {
      if (this.items[i].key == key) {
        value = this.items[i].value;
        return true;
      }
    }

    value = NULL;
    return false;
  }

  public function remove(key: int): bool {
    var i: int;

    for (i = 0; i < this.items.Size(); i += 1) {
      if (this.items[i].key == key) {
        this.items.Erase(i);
        return true;
      }
    }

    return false;
  }

  public function extractValues(out arr: array<MP_SU_HashMapBucketItem>) {
    var initial_size: int;
    var i: int;

    if (this.items.Size() <= 0) {
      return;
    }

    initial_size = arr.Size();

    arr.Grow(this.items.Size());

    for (i = 0; i < this.items.Size(); i += 1) {
      arr[initial_size + i] = this.items[i];
    }

    this.items.Clear();
  }
}

abstract class MP_SU_HashMapValue {
  public function isSome(): bool {
    return true;
  }
}

class MP_SU_HashMapValueNone extends MP_SU_HashMapValue {
  public function isSome(): bool {
    return false;
  }
}

class MP_SU_HashMapValueString extends MP_SU_HashMapValue {
  public var value: string;
}

function hm_fromString(str: string): MP_SU_HashMapValueString {
  var value: MP_SU_HashMapValueString;

  value = new MP_SU_HashMapValueString in thePlayer;
  value.value = str;

  return value;
}

class MP_SU_HashMapValueInt extends MP_SU_HashMapValue {
  public var value: int;
}

function hm_fromInt(number: int): MP_SU_HashMapValueInt {
  var value: MP_SU_HashMapValueInt;

  value = new MP_SU_HashMapValueInt in thePlayer;
  value.value = number;

  return value;
}

class MP_SU_HashMapValueRemotePlayer extends MP_SU_HashMapValue {
  public var value: r_RemotePlayer;
}

function hm_fromRemotePlayer(player: r_RemotePlayer): MP_SU_HashMapValueRemotePlayer {
  var value: MP_SU_HashMapValueRemotePlayer;

  value = new MP_SU_HashMapValueRemotePlayer in thePlayer;
  value.value = player;

  return value;
}

function hm_insertRemotePlayer(map: MP_SU_HashMap, key: int, player: r_RemotePlayer) {
  map.insert(key, hm_fromRemotePlayer(player));
}

function hm_getRemotePlayer(map: MP_SU_HashMap, key: int): r_RemotePlayer {
  var wrapped: MP_SU_HashMapValueRemotePlayer;

  wrapped = (MP_SU_HashMapValueRemotePlayer)map.get(key);

  if (wrapped) {
    return wrapped.value;
  }

  return NULL;
}

function hm_removeRemotePlayer(map: MP_SU_HashMap, key: int): bool {
  return map.remove(key);
}

function MP_SU_getNextPrimeNumber(number: int): int {
  if (number < 2) {
    return 2;
  }
  else if (number < 73) {
    return 73;
  }
  else if (number < 179) {
    return 179;
  }
  else if (number < 283) {
    return 283;
  }
  else if (number < 419) {
    return 419;
  }
  else if (number < 547) {
    return 547;
  }
  else if (number < 661) {
    return 661;
  }
  else if (number < 811) {
    return 811;
  }
  else if (number < 947) {
    return 947;
  }
  else if (number < 1087) {
    return 1087;
  }
  else if (number < 1229) {
    return 1229;
  }
  else if (number < 1381) {
    return 1381;
  }
  else if (number < 1523) {
    return 1523;
  }
  else if (number < 1663) {
    return 1663;
  }
  else if (number < 1823) {
    return 1823;
  }
  else if (number < 1993) {
    return 1993;
  }
  else if (number < 2131) {
    return 2131;
  }
  else if (number < 2293) {
    return 2293;
  }
  else if (number < 2437) {
    return 2437;
  }
  else if (number < 2621) {
    return 2621;
  }
  else if (number < 2749) {
    return 2749;
  }
  else if (number < 2909) {
    return 2909;
  }
  else if (number < 3083) {
    return 3083;
  }
  else if (number < 3259) {
    return 3259;
  }
  else if (number < 3433) {
    return 3433;
  }
  else if (number < 3581) {
    return 3581;
  }
  else if (number < 3733) {
    return 3733;
  }
  else if (number < 3911) {
    return 3911;
  }
  else if (number < 4073) {
    return 4073;
  }
  else if (number < 4241) {
    return 4241;
  }
  else if (number < 4421) {
    return 4421;
  }
  else if (number < 4591) {
    return 4591;
  }
  else if (number < 4759) {
    return 4759;
  }
  else if (number < 4943) {
    return 4943;
  }
  else if (number < 5099) {
    return 5099;
  }
  else if (number < 5281) {
    return 5281;
  }
  else if (number < 5449) {
    return 5449;
  }
  else if (number < 5641) {
    return 5641;
  }
  else if (number < 5801) {
    return 5801;
  }
  else if (number < 5953) {
    return 5953;
  }
  else if (number < 6143) {
    return 6143;
  }
  else if (number < 6311) {
    return 6311;
  }
  else if (number < 6481) {
    return 6481;
  }
  else if (number < 6679) {
    return 6679;
  }
  else if (number < 6841) {
    return 6841;
  }
  else if (number < 7001) {
    return 7001;
  }
  else if (number < 7211) {
    return 7211;
  }
  else if (number < 7417) {
    return 7417;
  }
  else if (number < 7573) {
    return 7573;
  }
  else if (number < 7727) {
    return 7727;
  }

  return number * 2 + 1;
}
