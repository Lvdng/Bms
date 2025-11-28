/*
Navicat MySQL Data Transfer

Source Server         : books-manage-system
Source Server Version : 50519
Source Host           : localhost:3306
Source Database       : db_book

Target Server Type    : MYSQL
Target Server Version : 50519
File Encoding         : 65001

Date: 2025-11-06 18:22:52
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `bookno`
-- ----------------------------
DROP TABLE IF EXISTS `bookno`;
CREATE TABLE `bookno` (
  `b_code` varchar(12) NOT NULL COMMENT '书本条码',
  `bs_id` varchar(12) NOT NULL COMMENT '书册编号（关联books表）',
  `b_name` varchar(50) NOT NULL COMMENT '书本名称',
  `u_id` varchar(10) DEFAULT NULL COMMENT '借阅用户（关联user表）',
  `b_borrow_date` date DEFAULT NULL COMMENT '借阅时间',
  `b_borrow` int(11) DEFAULT '1' COMMENT '借阅状态（0-借出 1-库存）',
  `b_status` int(11) NOT NULL DEFAULT '1' COMMENT '书本状态（0-禁用 1-正常）',
  PRIMARY KEY (`b_code`) USING BTREE,
  KEY `fk_books_bookno` (`bs_id`) USING BTREE,
  KEY `fk_user_bookno` (`u_id`) USING BTREE,
  CONSTRAINT `fk_books_bookno` FOREIGN KEY (`bs_id`) REFERENCES `books` (`bs_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='图书册表';

-- ----------------------------
-- Records of bookno
-- ----------------------------
INSERT INTO `bookno` VALUES ('H-00002-0', '00002', '中国近现代史', null, null, '1', '1');
INSERT INTO `bookno` VALUES ('H-00002-1', '00002', '中国近现代史', null, null, '1', '1');
INSERT INTO `bookno` VALUES ('H-00002-2', '00002', '中国近现代史', null, null, '1', '1');
INSERT INTO `bookno` VALUES ('H-00004-0', '00004', '中国古代史', 'admin', '2023-10-26', '0', '1');
INSERT INTO `bookno` VALUES ('H-00004-1', '00004', '中国古代史', '6', '2023-10-26', '0', '1');
INSERT INTO `bookno` VALUES ('H-00004-2', '00004', '中国古代史', null, null, '1', '1');
INSERT INTO `bookno` VALUES ('H-00004-3', '00004', '中国古代史', null, null, '1', '1');
INSERT INTO `bookno` VALUES ('L-00001-0', '00001', '雨季不再来', null, null, '1', '1');
INSERT INTO `bookno` VALUES ('L-00001-1', '00001', '雨季不再来', 'admin', '2023-10-26', '0', '1');
INSERT INTO `bookno` VALUES ('L-00001-2', '00001', '雨季不再来', null, null, '1', '1');
INSERT INTO `bookno` VALUES ('L-00001-3', '00001', '雨季不再来', null, null, '0', '0');
INSERT INTO `bookno` VALUES ('L-00003-0', '00003', '撒哈拉的故事', '', null, '1', '1');
INSERT INTO `bookno` VALUES ('L-00003-1', '00003', '撒哈拉的故事', null, null, '1', '1');
INSERT INTO `bookno` VALUES ('L-00003-2', '00003', '撒哈拉的故事', '', null, '1', '1');
INSERT INTO `bookno` VALUES ('L-00003-3', '00003', '撒哈拉的故事', null, null, '0', '0');

-- ----------------------------
-- Table structure for `books`
-- ----------------------------
DROP TABLE IF EXISTS `books`;
CREATE TABLE `books` (
  `bs_id` varchar(12) NOT NULL COMMENT '书册编号',
  `bs_isbn` varchar(18) NOT NULL COMMENT '书册ISBN',
  `bs_name` varchar(50) DEFAULT NULL COMMENT '书册名称',
  `s_id` int(11) DEFAULT NULL COMMENT '类别编号（关联sorts表）',
  `bs_auth` varchar(10) DEFAULT NULL COMMENT '书册作者',
  `bs_publish` varchar(20) DEFAULT NULL COMMENT '书册出版社',
  `bs_price` decimal(5,2) NOT NULL COMMENT '书册价格',
  `bs_volume` int(11) NOT NULL COMMENT '书册库存',
  `bs_inventory` int(11) NOT NULL COMMENT '书册剩余',
  `bs_status` int(11) NOT NULL COMMENT '状态（0-禁用 1-正常）',
  `bs_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`bs_id`) USING BTREE,
  KEY `fk_books_sorts` (`s_id`) USING BTREE,
  CONSTRAINT `fk_books_sorts` FOREIGN KEY (`s_id`) REFERENCES `sorts` (`s_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='图书总表';

-- ----------------------------
-- Records of books
-- ----------------------------
INSERT INTO `books` VALUES ('00001', '00001', '雨季不再来', '2', '三毛', '人民教育出版社', '39.90', '4', '3', '1', '2023-10-26 19:30:28');
INSERT INTO `books` VALUES ('00002', '00002', '中国近现代史', '1', '佚名', '人民教育出版社', '59.99', '3', '3', '1', '2023-10-16 01:12:45');
INSERT INTO `books` VALUES ('00003', '00003', '撒哈拉的故事', '2', '三毛', '清华大学出版社', '39.90', '4', '3', '1', '2023-10-16 01:20:44');
INSERT INTO `books` VALUES ('00004', '00004', '中国古代史', '1', '无', '清华大学出版社', '78.90', '4', '2', '1', '2023-10-24 19:47:16');

-- ----------------------------
-- Table structure for `borrow`
-- ----------------------------
DROP TABLE IF EXISTS `borrow`;
CREATE TABLE `borrow` (
  `br_serial` int(11) NOT NULL AUTO_INCREMENT COMMENT '流水编号',
  `b_code` varchar(12) NOT NULL COMMENT '书本条码（关联bookno表）',
  `u_id` varchar(6) NOT NULL COMMENT '流水用户（关联user表）',
  `br_debit_reply` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '借还时间',
  `br_borrow` int(11) NOT NULL COMMENT '借阅类别（0-借书 1-还书）',
  PRIMARY KEY (`br_serial`) USING BTREE,
  KEY `fk_user_borrow` (`u_id`) USING BTREE,
  KEY `fk_bookno_borrow` (`b_code`) USING BTREE,
  CONSTRAINT `fk_user_borrow` FOREIGN KEY (`u_id`) REFERENCES `user` (`u_id`),
  CONSTRAINT `fk_bookno_borrow` FOREIGN KEY (`b_code`) REFERENCES `bookno` (`b_code`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='图书借还流水表';

-- ----------------------------
-- Records of borrow
-- ----------------------------
INSERT INTO `borrow` VALUES ('42', 'L-00003-0', 'admin', '2023-10-16 01:24:11', '0');
INSERT INTO `borrow` VALUES ('43', 'L-00003-0', 'admin', '2023-10-16 01:24:21', '1');
INSERT INTO `borrow` VALUES ('44', 'H-00002-1', 'admin', '2023-10-17 00:00:00', '0');
INSERT INTO `borrow` VALUES ('45', 'L-00001-0', 'admin', '2023-10-24 19:40:09', '0');
INSERT INTO `borrow` VALUES ('46', 'L-00001-0', 'admin', '2023-10-24 19:40:54', '1');
INSERT INTO `borrow` VALUES ('47', 'H-00004-1', '6', '2023-10-26 16:29:03', '0');
INSERT INTO `borrow` VALUES ('48', 'L-00003-0', 'admin', '2023-10-16 01:24:11', '0');
INSERT INTO `borrow` VALUES ('49', 'L-00003-0', 'admin', '2023-10-16 01:24:21', '1');
INSERT INTO `borrow` VALUES ('50', 'H-00002-1', 'admin', '2023-10-17 00:00:00', '0');
INSERT INTO `borrow` VALUES ('51', 'L-00001-0', 'admin', '2023-10-24 19:40:09', '0');
INSERT INTO `borrow` VALUES ('52', 'L-00001-0', 'admin', '2023-10-24 19:40:54', '1');
INSERT INTO `borrow` VALUES ('53', 'H-00004-1', '6', '2023-10-26 16:29:03', '0');
INSERT INTO `borrow` VALUES ('54', 'L-00003-0', 'admin', '2023-10-16 01:24:11', '0');
INSERT INTO `borrow` VALUES ('55', 'L-00003-0', 'admin', '2023-10-16 01:24:21', '1');
INSERT INTO `borrow` VALUES ('56', 'H-00002-1', 'admin', '2023-10-17 00:00:00', '0');
INSERT INTO `borrow` VALUES ('57', 'L-00001-0', 'admin', '2023-10-24 19:40:09', '0');
INSERT INTO `borrow` VALUES ('58', 'L-00001-0', 'admin', '2023-10-24 19:40:54', '1');
INSERT INTO `borrow` VALUES ('59', 'H-00004-1', '6', '2023-10-26 16:29:03', '0');
INSERT INTO `borrow` VALUES ('60', 'L-00003-0', 'admin', '2023-10-16 01:24:11', '0');
INSERT INTO `borrow` VALUES ('61', 'L-00003-0', 'admin', '2023-10-16 01:24:21', '1');
INSERT INTO `borrow` VALUES ('62', 'H-00002-1', 'admin', '2023-10-17 00:00:00', '0');
INSERT INTO `borrow` VALUES ('63', 'L-00001-0', 'admin', '2023-10-24 19:40:09', '0');
INSERT INTO `borrow` VALUES ('64', 'L-00001-0', 'admin', '2023-10-24 19:40:54', '1');
INSERT INTO `borrow` VALUES ('65', 'H-00004-1', '6', '2023-10-26 16:29:03', '0');
INSERT INTO `borrow` VALUES ('66', 'H-00002-0', 'admin', '2023-10-26 22:28:08', '0');
INSERT INTO `borrow` VALUES ('67', 'H-00002-2', 'admin', '2023-10-26 22:28:19', '0');
INSERT INTO `borrow` VALUES ('68', 'H-00004-0', 'admin', '2023-10-26 22:28:29', '0');
INSERT INTO `borrow` VALUES ('69', 'H-00004-2', 'admin', '2023-10-26 22:28:40', '0');
INSERT INTO `borrow` VALUES ('70', 'H-00004-3', 'admin', '2023-10-26 22:28:47', '0');
INSERT INTO `borrow` VALUES ('71', 'L-00001-0', 'admin', '2023-10-26 22:28:56', '0');
INSERT INTO `borrow` VALUES ('72', 'L-00001-1', 'admin', '2023-10-26 22:29:06', '0');
INSERT INTO `borrow` VALUES ('73', 'L-00001-2', 'admin', '2023-10-26 22:29:30', '0');
INSERT INTO `borrow` VALUES ('74', 'H-00002-0', 'admin', '2023-10-26 22:30:30', '1');
INSERT INTO `borrow` VALUES ('75', 'H-00002-2', 'admin', '2023-10-26 22:30:35', '1');
INSERT INTO `borrow` VALUES ('76', 'H-00002-1', 'admin', '2023-10-26 22:30:41', '1');
INSERT INTO `borrow` VALUES ('77', 'H-00004-2', 'admin', '2023-10-26 22:30:45', '1');
INSERT INTO `borrow` VALUES ('78', 'L-00001-0', 'admin', '2023-10-26 22:30:51', '1');
INSERT INTO `borrow` VALUES ('79', 'L-00001-2', 'admin', '2023-10-26 22:31:07', '1');
INSERT INTO `borrow` VALUES ('80', 'H-00004-3', 'admin', '2023-10-26 22:31:12', '1');

-- ----------------------------
-- Table structure for `menu`
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu` (
  `m_id` int(11) NOT NULL COMMENT '菜单编号',
  `m_icon` varchar(30) NOT NULL COMMENT '菜单图标',
  `m_name` varchar(10) NOT NULL COMMENT '菜单名称',
  `m_path` varchar(10) NOT NULL COMMENT '菜单路径',
  `m_component` varchar(10) NOT NULL COMMENT '菜单组件',
  `m_status` int(11) NOT NULL COMMENT '菜单状态',
  `m_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '菜单创建时间',
  PRIMARY KEY (`m_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='菜单表';

-- ----------------------------
-- Records of menu
-- ----------------------------
INSERT INTO `menu` VALUES ('1', 'HomeOutlined', '首页', '/system', 'System', '1', '2023-09-29 19:04:59');
INSERT INTO `menu` VALUES ('2', 'LaptopOutlined', '路由管理', '/menu', 'Menu', '1', '2023-09-30 00:36:15');
INSERT INTO `menu` VALUES ('3', 'UsbOutlined', '用户管理', '/user', 'User', '1', '2023-09-29 19:04:59');
INSERT INTO `menu` VALUES ('4', 'UnlockOutlined', '用户-角色管理', '/user-role', 'UserRole', '0', '2023-10-07 17:23:31');
INSERT INTO `menu` VALUES ('5', 'TeamOutlined', '角色管理', '/role', 'Role', '1', '2023-09-29 19:04:59');
INSERT INTO `menu` VALUES ('6', 'UngroupOutlined', '角色-路由管理', '/role-menu', 'RoleMenu', '0', '2023-10-07 17:24:15');
INSERT INTO `menu` VALUES ('7', 'PicLeftOutlined', '类别管理', '/sorts', 'Sorts', '1', '2023-10-11 00:40:16');
INSERT INTO `menu` VALUES ('8', 'ReadOutlined', '图书管理', '/books', 'Books', '1', '2023-09-29 19:13:20');
INSERT INTO `menu` VALUES ('9', 'BookOutlined', '书本管理', '/bookno', 'Bookno', '1', '2023-09-30 00:32:59');
INSERT INTO `menu` VALUES ('10', 'ApartmentOutlined', '借阅管理', '/borrow', 'Borrow', '1', '2023-09-30 00:37:35');
INSERT INTO `menu` VALUES ('11', 'InteractionOutlined', '借阅服务', '/serve', 'Serve', '1', '2023-09-30 00:38:07');
INSERT INTO `menu` VALUES ('12', 'UserOutlined', '我的信息', '/myself', 'Myself', '1', '2023-09-30 00:38:44');

-- ----------------------------
-- Table structure for `role`
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `r_id` int(11) NOT NULL COMMENT '编号',
  `r_icon` varchar(30) DEFAULT NULL COMMENT '图标',
  `r_ide` varchar(10) NOT NULL COMMENT '角色名称',
  `r_limit_book` int(11) NOT NULL COMMENT '书本限制',
  `r_limit_day` int(11) NOT NULL COMMENT '天数限制',
  `r_status` int(11) NOT NULL COMMENT '状态（0-禁用 1-正常）',
  `r_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`r_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='权限表';

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('1', 'DesktopOutlined', '系统管理员', '50', '100', '1', '2023-09-29 20:35:14');
INSERT INTO `role` VALUES ('2', 'WalletOutlined', '超级管理员', '30', '60', '1', '2023-09-29 21:26:35');
INSERT INTO `role` VALUES ('3', 'AliwangwangOutlined', '图书管理员', '20', '40', '1', '2023-09-29 21:26:49');
INSERT INTO `role` VALUES ('4', 'DribbbleOutlined', '读者用户', '10', '20', '1', '2023-09-29 21:27:00');
INSERT INTO `role` VALUES ('5', 'InfoCircleOutlined', '游客', '5', '10', '0', '2023-10-07 18:09:58');

-- ----------------------------
-- Table structure for `role_menu`
-- ----------------------------
DROP TABLE IF EXISTS `role_menu`;
CREATE TABLE `role_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `r_id` int(11) NOT NULL COMMENT '角色编号（关联role表）',
  `m_id` int(11) NOT NULL COMMENT '菜单编号（关联menu表）',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_role_rm` (`r_id`) USING BTREE,
  KEY `fk_menu_rm` (`m_id`) USING BTREE,
  CONSTRAINT `fk_menu_rm` FOREIGN KEY (`m_id`) REFERENCES `menu` (`m_id`),
  CONSTRAINT `fk_role_rm` FOREIGN KEY (`r_id`) REFERENCES `role` (`r_id`)
) ENGINE=InnoDB AUTO_INCREMENT=220 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='权限路由关联表';

-- ----------------------------
-- Records of role_menu
-- ----------------------------
INSERT INTO `role_menu` VALUES ('1', '1', '1');
INSERT INTO `role_menu` VALUES ('2', '1', '2');
INSERT INTO `role_menu` VALUES ('3', '1', '3');
INSERT INTO `role_menu` VALUES ('4', '1', '4');
INSERT INTO `role_menu` VALUES ('5', '1', '5');
INSERT INTO `role_menu` VALUES ('6', '1', '6');
INSERT INTO `role_menu` VALUES ('7', '1', '7');
INSERT INTO `role_menu` VALUES ('8', '1', '8');
INSERT INTO `role_menu` VALUES ('9', '1', '9');
INSERT INTO `role_menu` VALUES ('10', '1', '10');
INSERT INTO `role_menu` VALUES ('11', '1', '11');
INSERT INTO `role_menu` VALUES ('12', '1', '12');
INSERT INTO `role_menu` VALUES ('13', '2', '1');
INSERT INTO `role_menu` VALUES ('14', '2', '3');
INSERT INTO `role_menu` VALUES ('15', '2', '4');
INSERT INTO `role_menu` VALUES ('16', '2', '5');
INSERT INTO `role_menu` VALUES ('17', '2', '6');
INSERT INTO `role_menu` VALUES ('18', '2', '7');
INSERT INTO `role_menu` VALUES ('19', '2', '8');
INSERT INTO `role_menu` VALUES ('20', '2', '9');
INSERT INTO `role_menu` VALUES ('21', '2', '10');
INSERT INTO `role_menu` VALUES ('22', '2', '11');
INSERT INTO `role_menu` VALUES ('23', '2', '12');
INSERT INTO `role_menu` VALUES ('24', '3', '1');
INSERT INTO `role_menu` VALUES ('25', '3', '7');
INSERT INTO `role_menu` VALUES ('26', '3', '8');
INSERT INTO `role_menu` VALUES ('27', '3', '9');
INSERT INTO `role_menu` VALUES ('28', '3', '10');
INSERT INTO `role_menu` VALUES ('29', '3', '11');
INSERT INTO `role_menu` VALUES ('30', '3', '12');
INSERT INTO `role_menu` VALUES ('31', '4', '1');
INSERT INTO `role_menu` VALUES ('32', '4', '11');
INSERT INTO `role_menu` VALUES ('33', '4', '12');
INSERT INTO `role_menu` VALUES ('34', '5', '1');
INSERT INTO `role_menu` VALUES ('35', '5', '11');
INSERT INTO `role_menu` VALUES ('36', '5', '12');

-- ----------------------------
-- Table structure for `sorts`
-- ----------------------------
DROP TABLE IF EXISTS `sorts`;
CREATE TABLE `sorts` (
  `s_id` int(11) NOT NULL COMMENT '编号',
  `s_icon` varchar(30) DEFAULT NULL COMMENT '图标',
  `s_sort` varchar(16) NOT NULL COMMENT '类别名称',
  `s_code` varchar(2) NOT NULL COMMENT '类别代码',
  `s_status` int(11) NOT NULL COMMENT '状态（0-禁用 1-正常）',
  `s_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`s_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='图书类别表';

-- ----------------------------
-- Records of sorts
-- ----------------------------
INSERT INTO `sorts` VALUES ('1', 'KeyOutlined', '历史', 'H', '1', '2023-10-11 01:14:00');
INSERT INTO `sorts` VALUES ('2', 'BorderOuterOutlined', '文学', 'L', '1', '2023-10-11 01:18:30');
INSERT INTO `sorts` VALUES ('3', 'BgColorsOutlined', '科学', 'S', '1', '2023-10-11 01:22:21');
INSERT INTO `sorts` VALUES ('4', 'RedditOutlined', '心理', 'M', '1', '2023-10-11 01:31:35');
INSERT INTO `sorts` VALUES ('5', 'ScheduleOutlined', '外语', 'E', '0', '2023-10-11 16:24:10');

-- ----------------------------
-- Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `u_id` varchar(10) NOT NULL COMMENT '账号',
  `u_pwd` varchar(100) NOT NULL COMMENT '密码',
  `u_name` varchar(8) NOT NULL COMMENT '姓名',
  `u_sex` varchar(1) DEFAULT NULL COMMENT '性别（男/女）',
  `u_birth` date DEFAULT NULL COMMENT '出生日期',
  `u_status` int(11) NOT NULL COMMENT '状态（0-挂失 1-正常）',
  `u_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  PRIMARY KEY (`u_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='账号信息表';

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'c4ca4238a0b923820dcc509a6f75849b', '刘繁星', '女', '2001-02-02', '1', '2023-10-26 15:37:28');
INSERT INTO `user` VALUES ('2', 'c4ca4238a0b923820dcc509a6f75849b', '彭于晏', '男', '1970-01-07', '1', '2023-10-26 15:37:28');
INSERT INTO `user` VALUES ('3', 'c4ca4238a0b923820dcc509a6f75849b', '蔡徐坤', '男', '1970-01-07', '1', '2023-10-26 15:37:28');
INSERT INTO `user` VALUES ('4', 'c4ca4238a0b923820dcc509a6f75849b', '哈哈哈', '女', '2023-10-03', '1', '2023-10-26 15:37:28');
INSERT INTO `user` VALUES ('5', 'c4ca4238a0b923820dcc509a6f75849b', '何福海', '男', '2001-10-02', '1', '2023-10-26 15:37:28');
INSERT INTO `user` VALUES ('6', 'c4ca4238a0b923820dcc509a6f75849b', '666', '男', '1959-12-31', '1', '2023-10-26 15:58:56');
INSERT INTO `user` VALUES ('admin', 'c4ca4238a0b923820dcc509a6f75849b', '周星驰', '男', '1960-01-02', '1', '2023-09-29 21:04:23');

-- ----------------------------
-- Table structure for `user_role`
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `u_id` varchar(10) NOT NULL COMMENT '用户账号（关联user表）',
  `r_id` int(11) NOT NULL COMMENT '角色编号（关联role表）',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_user_ur` (`u_id`) USING BTREE,
  KEY `fk_role_ur` (`r_id`) USING BTREE,
  CONSTRAINT `fk_role_ur` FOREIGN KEY (`r_id`) REFERENCES `role` (`r_id`),
  CONSTRAINT `fk_user_ur` FOREIGN KEY (`u_id`) REFERENCES `user` (`u_id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='用户权限关联表';

-- ----------------------------
-- Records of user_role
-- ----------------------------
INSERT INTO `user_role` VALUES ('36', 'admin', '1');
INSERT INTO `user_role` VALUES ('47', '1', '2');
INSERT INTO `user_role` VALUES ('48', '2', '3');
INSERT INTO `user_role` VALUES ('49', '3', '4');
INSERT INTO `user_role` VALUES ('50', '4', '5');
INSERT INTO `user_role` VALUES ('51', '5', '4');
INSERT INTO `user_role` VALUES ('52', '6', '5');
