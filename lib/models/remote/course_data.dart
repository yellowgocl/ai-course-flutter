import 'package:course/models/enum/enums.dart';
import 'package:course/models/remote/block_data.dart';
import 'package:course/models/remote/media_data.dart';
import 'package:course/models/base_data.dart';
import 'package:course/utils/commonUtil.dart';

class CourseData extends BaseData {
  CourseData(Map<String, dynamic> source): super.fromJson(source);

  final List _courseMode = [0,1,2];

  MediaData get media{
    var r = get('media', null);
    if (r is Map) {
      r = MediaData.fromJson(r);
      this.media = r;
    } else if (get('video') != null) {
      r = MediaData(src: get('video'), name: get('name'), duration: CommonUtil.getDuration(get('duration')));
    }
    return r;
    
  }

  set media(MediaData val) {
    set('media', val);
  }

  set blocks(List<BlockData> val) {
    set('points', val);
  }
  List<BlockData> get blocks{
    List r = get('points', null);
    if (r is List<BlockData>) {
      return r;
    }
    List<BlockData> result = [];
    if (r != null && r.length > 0) {
      int index = 0;
      r.forEach((b) {
        if (b is Map) {
          result.add(BlockData(b)..index = index);
          index ++;
        }
      }); 
    }
    this.blocks = result;
    return result;
  }

  // 获取blockData下标
  int blockIndex(BlockData blockData) {
    int index = 0;
    // return this.blocks.indexOf(blockData);
    for (BlockData block in this.blocks) {
      if (block.id == blockData.id) {
        return index;
      }
      index ++;
    }
    return -1;
  }

  // 获取contextId对应blockData
  BlockData blockByContextId(contextId) {
    for (BlockData block in this.blocks) {
      if (block.id == contextId) {
        return block;
      }
    }
    return null;
  }

  // 获取下一个blockData数据
  BlockData nextBlock(BlockData blockData, [int contextId]) {
    if (contextId == null || contextId == 0) {
      int index = this.blockIndex(blockData);
      if (index < 0) {
        return null;
      }
      int nextIndex = index + 1;
      if (nextIndex >= this.blocks.length) {
        return null;
      }
      return this.blocks[nextIndex];
    }

    return this.blockByContextId(contextId);
  }

  List get courseBlocks {
    List blockList = List();
    for (BlockData block in blocks) {
      if (block.isQuestion) {
        blockList.add(block);
      }
    }

    return blockList;
  }

  int get updateDate {
    return get('updateDate', 0);
  }
}