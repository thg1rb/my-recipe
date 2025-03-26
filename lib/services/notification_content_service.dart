import 'package:flutter/widgets.dart';
import 'package:my_recipe/models/notification_content.dart';

class NotificationContentService {
  // List of notification contents
  static final List<NotificationContent> _notifications = <NotificationContent>[
    NotificationContent(
      title: "😋 หิวไหม? เรามีสูตรแก้หิว!",
      body: "มาดูสูตรอาหารใกล้ตัวคุณ พร้อมวิธีทำง่ายๆ ในไม่กี่ขั้นตอน",
    ),
    NotificationContent(
      title: "🎉 สูตรพิเศษสำหรับวันหยุดนี้!",
      body: "อย่ารอช้า! เปิดแอปดูสูตรเด็ดที่คัดมาเพื่อคุณโดยเฉพาะ",
    ),
    NotificationContent(
      title: "👩‍🍳 คุณมีสูตรอาหารสุดเจ๋งไหม?",
      body:
          "มาแบ่งปันสูตรของคุณในแอปเรา และติดตามสูตรอื่นๆ จากชุมชนคนรักอาหาร!",
    ),
    NotificationContent(
      title: "🍽️ มื้อเย็นวันนี้ทำอะไรดี?",
      body: "เรามีไอเดียอาหารอร่อยๆ มาให้คุณเลือก!",
    ),
    NotificationContent(
      title: "📲 เปิดแอปเดียว ได้ทุกสูตร!",
      body: "ไม่ต้องหาที่ไหนอีก มีสูตรอาหารครบจบในแอปเดียว",
    ),
    NotificationContent(
      title: "🎂 เตรียมพร้อมสำหรับวันพิเศษ!",
      body: "คลิกดูสูตรขนมและอาหารสำหรับโอกาสสำคัญของคุณ",
    ),
    NotificationContent(
      title: "🌎 อาหารจากทั่วโลกในมือคุณ!",
      body: "คลิกดูสูตรอาหารนานาชาติ ที่ทำเองได้ที่บ้านไม่ยาก",
    ),
    NotificationContent(
      title: "💰 ทำอาหารเองประหยัดกว่า!",
      body: "สูตรอาหารราคาประหยัด แต่รสชาติไม่ประหยัด",
    ),
    NotificationContent(
      title: "🧾 เอาสูตรอาหารของคุณมาโชว์หน่อย!",
      body: "มาโพสต์สูตรอาหารของคุณเพื่อแบ่งปันกับชุมชนคนรักอาหารกันเถอะ",
    ),
    NotificationContent(
      title: "🥄 เราคิดถึงคุณนะ!",
      body: "มาเช็กอินกันหน่อย มีสูตรใหม่ๆ มาให้ลองแล้ว",
    ),
  ];

  // Get a random notification content
  NotificationContent get randomContent {
    final int index =
        DateTime.now().millisecondsSinceEpoch % _notifications.length;
    return _notifications[index];
  }
}
