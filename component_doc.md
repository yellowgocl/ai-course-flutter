# AI-Course(AI智能课件)-组件描述
> 用于根据json描述填充生成渲染组件

## ***enums***
### **WidgetType**
``(指定渲染的组件类型)``

|   value            |   index       | description   |
|   ---             |   ----        |  ------       |
| screen            | 0             | 视图容器的根类型 |
| image             | 1             | 图片容器 |
| text              | 2             | 文本容器 |
| viewGroup         | 3             | 组件容器，所有组件的拼合可以通过此类型进行包装 |
| title             | 4             | （特性化控件）课程标题 |
| questionType      | 5             | （特性化控件）课程问题类型文本 |
| button            | 6             | 按钮容器 |
| flare             | 7             | [flr动画容器](https://www.2dimensions.com/) |
| video             | 8             | 视频容器 |
| recordButton      | 9             | （特性化控件）录音按钮+倒计时bar |
| question          | 10            | （特性化控件）课程问题文本 |

### **transformConversionType**
> #### (size的单位指转换标识)

### **LayoutType**
> #### (viewGroup的布局类型)
|   value            |   index       | description   |
|   ---             |   ----        |  ------       |
| constraint            | 0             | 约束stack布局 |
| row             | 1             | 横向布局 |
| column              | 2             | 纵向布局 |
| position         | 3             | 根据子空间的option.position布局，目前未实现，有可能和constraint合并，暂不要使用！！ |

### **AlignmentType**
> #### 约束布局的位置描述

|                |              |               |
|   ---             |   ----        |  ------       |
| topLeft ***(8)***            | topCenter ***(1)***       | topRight ***(2)*** |
| centerLeft ***(7)***         | center ***(9)***          | centerRight ***(3)*** |
| bottomLeft ***(6)***              | bottomCenter ***(5)***           | bottomRight ***(4)*** | 

---
## **组件类描述**
### ***WidgetData***
> 组件数据基类

|   key        |   type     |   required | default value   |  description |
|   ---        |   ----     |  ---        | ---  |  ------      |
|   id         |  String    |       no     | null |  组件唯一标识  |
|parentId      | String     | no            | null |   父级组件唯一标识（目前未实际使用，预留字段）
|name          | String      |no             | null || 组件名称       |
|type          | [WidgetType](#widgetType) | yes | null | 指定组件渲染的类型|
|option        | [WidgetOption](#widgetOption)| yes | | null | 控件配置项 |

---

### ***ViewGroupData***
##### *extends [WidgetData](#widgetdata)* 
view容器控件描述数据
|   key        |   type     |   required | default value   |  description |
|   ---        |   ----     |  ---        | ---  |  ------      |

---

### ***WidgetOptionData***
组件数据配置基类
|   key        |   type     |   required | default value    |  description |
|   ---        |   ----     |  ---       | ---   |  ------      |
|   id         |  String    |       no    | null  |  唯一标识 （目前未实际使用，预留字段） |
|size      | [Map, double]     | no            | null | 尺寸描述，容易指定外框容器宽高，当传入值为double，将默认构建一个宽高相等的rect，Map类型必须包含至少一个width或者height的字段描述，缺省边赋值double.infinite |
|alignment          | int      |no        | 9  | 子级布局方式       |
|padding        | [Map, int] | no | null | 控件配置项 |
|transformConversionType |[TransformConversionType](#transformConversionType)| no | null | -- |
|flex | int | no | null |只单独对应处在WidgetType.viewGroup类型，layout不为约束布局的情况下起效 |
|decoration | DecorationData | no | null | 装饰器描述 |
|constraints | Constraints | no | null | 边界约束描述 |

---

### ***ViewGroupOptionData***
##### *extends [WidgetOptionData](#widgetOptionData)* 
容器组件数据配置类
|   key        |   type     |   required | default value   |  description |
|   ---        |   ----     |  ---        | ---  |  ------      |
|   alignmentSelf         |  int    |       no     | null |  相对容器自身的布局描述，仅使用在组件定义时候具备Container对象的组件  |
|mainAxisAlignment | MainAxisAlignment | no | null | layout描述为LayoutType.row或LayoutType.column的主轴方向布局描述
|crossAxisAlignment | CrossAxisAlignment | no | null | layout描述为LayoutType.row或LayoutType.column的次轴方向布局描述
|layout | [LayoutType](#layouttype) | no | null | 布局类型

```
{
    "size": { "width": 200, "height": 100 },
    "alignment": AlignmentType,
    "alignmentSelf": AlignmentType,
    "mainAxisAlignment": "start",
    "crossAxisAlignment": "center",
    "layout": 0 // 0-3,
    "transformConversionType": "viewport",
    "padding": { 
        "left": 0, 
        "right": 0, 
        "top": 0, 
        "bottom": 0 },
    "decoration": DecorationData,
    "constraints": {
        maxWidth: null, 
        maxHeight: null,
        minWidth: null, 
        minHeight: null, 
        transformConversionType: "viewport"
    }
}
```

---

### ***TextOptionData***
##### *extends [ViewGroupOptionData](#viewgroupoptiondata)* 
容器组件数据配置类
|   key        |   type     |   required | default value   |  description |
|   ---        |   ----     |  ---        | ---  |  ------      |
|   text         |  String    |       yes     | null |  文本内容  |
|   textThemeType         |  Striing    |       no     | Theme.textTheme |  文本主题  |
|   fontWeight         |  Striing    |       no     | null |  文本加粗比重  |
|   fontFamily         |  Striing    |       no     | null |  文本字体  |
|   textAlign         |  TextAlign    |       no     | null |  文本布局  |
|   textDirection         |  TextDirection    |       no     | null |  文本方向  |
|   locale         |  Locale    |       no     | null |  文本地区（i18n）  |
|   strutStyle         |  StrutStyle    |       no     | null |  文本支柱风格，最小行高描述  |
|   textWidthBasis         |  TextWidthBasis    |       no     | null |  指定一行或多行的文本宽度方式（TextWidthBasis.parent, TextWidthBasis. longesLine）  |
|   softWrap         |  bool    |       no     | true |  自动换行  |
|   overflow         |  TextOverflow    |       no     | null |  文本溢出处理样式（TextOverflow.ellipsis, 文本溢出处理样式（TextOverflow.clip, 文本溢出处理样式（TextOverflow.fade）  |
|   textScaleFactor         |  double    |       no     | 1.0 |  文本相对当前文字的缩放比  |
|   semanticsLabel         |  double    |       no     | null |  文本语义标签  |
|   maxLines         |  int    |       no     | null |  最大行数  |
|   textStyle         |  TextStyle    |       no     | null |  文本样式  |
