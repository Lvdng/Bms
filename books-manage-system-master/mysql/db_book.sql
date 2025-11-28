/*
 Navicat Premium Dump SQL

 Source Server         : books-manage-system
 Source Server Type    : MySQL
 Source Server Version : 90001 (9.0.1)
 Source Host           : localhost:3306
 Source Schema         : db_book

 Target Server Type    : MySQL
 Target Server Version : 90001 (9.0.1)
 File Encoding         : 65001

 Date: 28/11/2025 12:09:38
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for bookno
-- ----------------------------
DROP TABLE IF EXISTS `bookno`;
CREATE TABLE `bookno`  (
  `b_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '书本条码',
  `bs_id` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '书册编号（关联books表）',
  `b_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '书本名称',
  `u_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '借阅用户（关联user表）',
  `b_borrow_date` date NULL DEFAULT NULL COMMENT '借阅时间',
  `b_borrow` int NULL DEFAULT 1 COMMENT '借阅状态（0-借出 1-库存）',
  `b_status` int NOT NULL DEFAULT 1 COMMENT '书本状态（0-禁用 1-正常）',
  PRIMARY KEY (`b_code`) USING BTREE,
  INDEX `fk_books_bookno`(`bs_id` ASC) USING BTREE,
  INDEX `fk_user_bookno`(`u_id` ASC) USING BTREE,
  CONSTRAINT `fk_books_bookno` FOREIGN KEY (`bs_id`) REFERENCES `books` (`bs_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '图书册表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bookno
-- ----------------------------
INSERT INTO `bookno` VALUES ('H-00002-0', '00002', '中国近现代史', '5', '2025-11-13', 0, 1);
INSERT INTO `bookno` VALUES ('H-00002-1', '00002', '中国近现代史', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('H-00002-2', '00002', '中国近现代史', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('H-00004-0', '00004', '中国古代史', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('H-00004-1', '00004', '中国古代史', '', NULL, 1, 1);
INSERT INTO `bookno` VALUES ('H-00004-2', '00004', '中国古代史', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('H-00004-3', '00004', '中国古代史', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('L-00001-0', '00001', '雨季不再来', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('L-00001-1', '00001', '雨季不再来', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('L-00001-2', '00001', '雨季不再来', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('L-00001-3', '00001', '雨季不再来', NULL, NULL, 0, 0);
INSERT INTO `bookno` VALUES ('L-00003-0', '00003', '撒哈拉的故事', '', NULL, 1, 1);
INSERT INTO `bookno` VALUES ('L-00003-1', '00003', '撒哈拉的故事', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('L-00003-2', '00003', '撒哈拉的故事', '', NULL, 1, 1);
INSERT INTO `bookno` VALUES ('L-00003-3', '00003', '撒哈拉的故事', NULL, NULL, 0, 0);
INSERT INTO `bookno` VALUES ('S-00006-0', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-1', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-10', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-11', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-12', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-13', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-14', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-15', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-16', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-17', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-18', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-19', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-2', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-20', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-21', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-22', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-23', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-24', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-25', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-26', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-27', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-28', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-29', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-3', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-30', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-31', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-32', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-33', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-34', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-35', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-36', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-37', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-38', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-39', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-4', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-40', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-41', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-42', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-43', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-44', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-45', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-46', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-47', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-48', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-49', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-5', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-50', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-51', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-52', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-53', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-54', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-55', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-56', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-57', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-58', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-59', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-6', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-60', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-61', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-7', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-8', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00006-9', '00006', '软件工程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-0', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-1', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-10', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-11', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-12', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-13', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-14', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-15', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-16', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-17', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-18', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-19', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-2', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-20', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-21', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-22', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-23', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-24', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-25', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-26', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-27', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-28', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-29', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-3', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-30', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-31', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-32', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-33', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-34', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-35', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-36', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-37', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-38', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-39', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-4', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-40', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-41', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-42', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-43', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-44', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-45', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-46', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-47', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-48', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-49', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-5', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-50', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-51', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-52', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-53', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-54', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-55', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-56', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-57', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-58', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-59', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-6', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-60', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-61', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-7', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-8', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-00007-9', '00007', 'SpringBoot企业级开发教程', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-5-0', '5', 'C语言程序设计基础', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-5-1', '5', 'C语言程序设计基础', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-5-2', '5', 'C语言程序设计基础', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-5-3', '5', 'C语言程序设计基础', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-5-4', '5', 'C语言程序设计基础', NULL, NULL, 1, 1);
INSERT INTO `bookno` VALUES ('S-5-5', '5', 'C语言程序设计基础', NULL, NULL, 1, 1);

-- ----------------------------
-- Table structure for books
-- ----------------------------
DROP TABLE IF EXISTS `books`;
CREATE TABLE `books`  (
  `bs_id` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '书册编号',
  `bs_isbn` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '书册ISBN',
  `bs_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '书册名称',
  `s_id` int NULL DEFAULT NULL COMMENT '类别编号（关联sorts表）',
  `bs_auth` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '书册作者',
  `bs_publish` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '书册出版社',
  `bs_price` decimal(5, 2) NOT NULL COMMENT '书册价格',
  `bs_volume` int NOT NULL COMMENT '书册库存',
  `bs_inventory` int NOT NULL COMMENT '书册剩余',
  `bs_status` int NOT NULL COMMENT '状态（0-禁用 1-正常）',
  `bs_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`bs_id`) USING BTREE,
  INDEX `fk_books_sorts`(`s_id` ASC) USING BTREE,
  CONSTRAINT `fk_books_sorts` FOREIGN KEY (`s_id`) REFERENCES `sorts` (`s_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '图书总表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of books
-- ----------------------------
INSERT INTO `books` VALUES ('00001', '00001', '雨季不再来', 2, '三毛', '人民教育出版社', 39.90, 4, 4, 1, '2023-10-26 19:30:28');
INSERT INTO `books` VALUES ('00002', '00002', '中国近现代史', 1, '佚名', '人民教育出版社', 59.99, 3, 2, 1, '2023-10-16 01:12:45');
INSERT INTO `books` VALUES ('00003', '00003', '撒哈拉的故事', 2, '三毛', '清华大学出版社', 39.90, 4, 3, 1, '2023-10-16 01:20:44');
INSERT INTO `books` VALUES ('00004', '00004', '中国古代史', 1, '无', '清华大学出版社', 78.90, 4, 3, 1, '2023-10-24 19:47:16');
INSERT INTO `books` VALUES ('00006', '9787040610109', '软件工程', 3, '毛新军', '高等教育出版社', 79.00, 62, 62, 1, '2025-11-20 17:50:25');
INSERT INTO `books` VALUES ('00007', '9787115634382', 'SpringBoot企业级开发教程', 3, '黑马程序员', '人民邮电出版社', 59.80, 62, 62, 1, '2025-11-20 18:11:16');
INSERT INTO `books` VALUES ('5', '2341242345', 'C语言程序设计基础', 3, '无', '清华大学出版社', 59.90, 6, 6, 1, '2025-11-07 17:30:07');

-- ----------------------------
-- Table structure for borrow
-- ----------------------------
DROP TABLE IF EXISTS `borrow`;
CREATE TABLE `borrow`  (
  `br_serial` int NOT NULL AUTO_INCREMENT COMMENT '流水编号',
  `b_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '书本条码（关联bookno表）',
  `u_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '流水用户（关联user表）',
  `br_debit_reply` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '借还时间',
  `br_borrow` int NOT NULL COMMENT '借阅类别（0-借书 1-还书）',
  PRIMARY KEY (`br_serial`) USING BTREE,
  INDEX `fk_user_borrow`(`u_id` ASC) USING BTREE,
  INDEX `fk_bookno_borrow`(`b_code` ASC) USING BTREE,
  CONSTRAINT `fk_bookno_borrow` FOREIGN KEY (`b_code`) REFERENCES `bookno` (`b_code`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_user_borrow` FOREIGN KEY (`u_id`) REFERENCES `user` (`u_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 94 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '图书借还流水表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of borrow
-- ----------------------------
INSERT INTO `borrow` VALUES (42, 'L-00003-0', 'admin', '2023-10-16 01:24:11', 0);
INSERT INTO `borrow` VALUES (43, 'L-00003-0', 'admin', '2023-10-16 01:24:21', 1);
INSERT INTO `borrow` VALUES (44, 'H-00002-1', 'admin', '2023-10-17 00:00:00', 0);
INSERT INTO `borrow` VALUES (45, 'L-00001-0', 'admin', '2023-10-24 19:40:09', 0);
INSERT INTO `borrow` VALUES (46, 'L-00001-0', 'admin', '2023-10-24 19:40:54', 1);
INSERT INTO `borrow` VALUES (47, 'H-00004-1', '6', '2023-10-26 16:29:03', 0);
INSERT INTO `borrow` VALUES (48, 'L-00003-0', 'admin', '2023-10-16 01:24:11', 0);
INSERT INTO `borrow` VALUES (49, 'L-00003-0', 'admin', '2023-10-16 01:24:21', 1);
INSERT INTO `borrow` VALUES (50, 'H-00002-1', 'admin', '2023-10-17 00:00:00', 0);
INSERT INTO `borrow` VALUES (51, 'L-00001-0', 'admin', '2023-10-24 19:40:09', 0);
INSERT INTO `borrow` VALUES (52, 'L-00001-0', 'admin', '2023-10-24 19:40:54', 1);
INSERT INTO `borrow` VALUES (53, 'H-00004-1', '6', '2023-10-26 16:29:03', 0);
INSERT INTO `borrow` VALUES (54, 'L-00003-0', 'admin', '2023-10-16 01:24:11', 0);
INSERT INTO `borrow` VALUES (55, 'L-00003-0', 'admin', '2023-10-16 01:24:21', 1);
INSERT INTO `borrow` VALUES (56, 'H-00002-1', 'admin', '2023-10-17 00:00:00', 0);
INSERT INTO `borrow` VALUES (57, 'L-00001-0', 'admin', '2023-10-24 19:40:09', 0);
INSERT INTO `borrow` VALUES (58, 'L-00001-0', 'admin', '2023-10-24 19:40:54', 1);
INSERT INTO `borrow` VALUES (59, 'H-00004-1', '6', '2023-10-26 16:29:03', 0);
INSERT INTO `borrow` VALUES (60, 'L-00003-0', 'admin', '2023-10-16 01:24:11', 0);
INSERT INTO `borrow` VALUES (61, 'L-00003-0', 'admin', '2023-10-16 01:24:21', 1);
INSERT INTO `borrow` VALUES (62, 'H-00002-1', 'admin', '2023-10-17 00:00:00', 0);
INSERT INTO `borrow` VALUES (63, 'L-00001-0', 'admin', '2023-10-24 19:40:09', 0);
INSERT INTO `borrow` VALUES (64, 'L-00001-0', 'admin', '2023-10-24 19:40:54', 1);
INSERT INTO `borrow` VALUES (65, 'H-00004-1', '6', '2023-10-26 16:29:03', 0);
INSERT INTO `borrow` VALUES (66, 'H-00002-0', 'admin', '2023-10-26 22:28:08', 0);
INSERT INTO `borrow` VALUES (67, 'H-00002-2', 'admin', '2023-10-26 22:28:19', 0);
INSERT INTO `borrow` VALUES (68, 'H-00004-0', 'admin', '2023-10-26 22:28:29', 0);
INSERT INTO `borrow` VALUES (69, 'H-00004-2', 'admin', '2023-10-26 22:28:40', 0);
INSERT INTO `borrow` VALUES (70, 'H-00004-3', 'admin', '2023-10-26 22:28:47', 0);
INSERT INTO `borrow` VALUES (71, 'L-00001-0', 'admin', '2023-10-26 22:28:56', 0);
INSERT INTO `borrow` VALUES (72, 'L-00001-1', 'admin', '2023-10-26 22:29:06', 0);
INSERT INTO `borrow` VALUES (73, 'L-00001-2', 'admin', '2023-10-26 22:29:30', 0);
INSERT INTO `borrow` VALUES (74, 'H-00002-0', 'admin', '2023-10-26 22:30:30', 1);
INSERT INTO `borrow` VALUES (75, 'H-00002-2', 'admin', '2023-10-26 22:30:35', 1);
INSERT INTO `borrow` VALUES (76, 'H-00002-1', 'admin', '2023-10-26 22:30:41', 1);
INSERT INTO `borrow` VALUES (77, 'H-00004-2', 'admin', '2023-10-26 22:30:45', 1);
INSERT INTO `borrow` VALUES (78, 'L-00001-0', 'admin', '2023-10-26 22:30:51', 1);
INSERT INTO `borrow` VALUES (79, 'L-00001-2', 'admin', '2023-10-26 22:31:07', 1);
INSERT INTO `borrow` VALUES (80, 'H-00004-3', 'admin', '2023-10-26 22:31:12', 1);
INSERT INTO `borrow` VALUES (81, 'L-00001-1', 'admin', '2025-11-07 15:06:44', 1);
INSERT INTO `borrow` VALUES (82, 'H-00004-0', 'admin', '2025-11-07 15:06:57', 1);
INSERT INTO `borrow` VALUES (83, 'H-00002-1', '5', '2025-11-07 15:10:47', 0);
INSERT INTO `borrow` VALUES (84, 'H-00002-1', '5', '2025-11-07 15:11:02', 1);
INSERT INTO `borrow` VALUES (85, 'H-00002-1', '5', '2025-11-07 15:11:16', 0);
INSERT INTO `borrow` VALUES (86, 'H-00002-0', '1', '2025-11-13 17:05:40', 0);
INSERT INTO `borrow` VALUES (87, 'H-00002-0', '1', '2025-11-13 17:06:08', 1);
INSERT INTO `borrow` VALUES (88, 'H-00002-0', '5', '2025-11-13 17:07:23', 0);
INSERT INTO `borrow` VALUES (89, 'H-00002-1', '5', '2025-11-13 17:07:45', 1);
INSERT INTO `borrow` VALUES (90, 'S-00006-0', '1', '2025-11-20 17:50:48', 0);
INSERT INTO `borrow` VALUES (91, 'S-00006-0', '1', '2025-11-20 17:51:54', 1);
INSERT INTO `borrow` VALUES (92, 'S-00006-0', '1', '2025-11-20 17:52:34', 0);
INSERT INTO `borrow` VALUES (93, 'S-00006-0', '1', '2025-11-20 17:53:34', 1);

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu`  (
  `m_id` int NOT NULL COMMENT '菜单编号',
  `m_icon` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单图标',
  `m_name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单名称',
  `m_path` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单路径',
  `m_component` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单组件',
  `m_status` int NOT NULL COMMENT '菜单状态',
  `m_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '菜单创建时间',
  PRIMARY KEY (`m_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of menu
-- ----------------------------
INSERT INTO `menu` VALUES (1, 'HomeOutlined', '首页', '/system', 'System', 1, '2023-09-29 19:04:59');
INSERT INTO `menu` VALUES (2, 'LaptopOutlined', '路由管理', '/menu', 'Menu', 1, '2023-09-30 00:36:15');
INSERT INTO `menu` VALUES (3, 'UsbOutlined', '用户管理', '/user', 'User', 1, '2023-09-29 19:04:59');
INSERT INTO `menu` VALUES (4, 'UnlockOutlined', '用户-角色管理', '/user-role', 'UserRole', 0, '2023-10-07 17:23:31');
INSERT INTO `menu` VALUES (5, 'TeamOutlined', '角色管理', '/role', 'Role', 1, '2023-09-29 19:04:59');
INSERT INTO `menu` VALUES (6, 'UngroupOutlined', '角色-路由管理', '/role-menu', 'RoleMenu', 0, '2023-10-07 17:24:15');
INSERT INTO `menu` VALUES (7, 'PicLeftOutlined', '类别管理', '/sorts', 'Sorts', 1, '2023-10-11 00:40:16');
INSERT INTO `menu` VALUES (8, 'ReadOutlined', '图书管理', '/books', 'Books', 1, '2023-09-29 19:13:20');
INSERT INTO `menu` VALUES (9, 'BookOutlined', '书本管理', '/bookno', 'Bookno', 1, '2023-09-30 00:32:59');
INSERT INTO `menu` VALUES (10, 'ApartmentOutlined', '借阅管理', '/borrow', 'Borrow', 1, '2023-09-30 00:37:35');
INSERT INTO `menu` VALUES (11, 'InteractionOutlined', '借阅服务', '/serve', 'Serve', 1, '2023-09-30 00:38:07');
INSERT INTO `menu` VALUES (12, 'UserOutlined', '我的信息', '/myself', 'Myself', 1, '2023-09-30 00:38:44');

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `r_id` int NOT NULL COMMENT '编号',
  `r_icon` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图标',
  `r_ide` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `r_limit_book` int NOT NULL COMMENT '书本限制',
  `r_limit_day` int NOT NULL COMMENT '天数限制',
  `r_status` int NOT NULL COMMENT '状态（0-禁用 1-正常）',
  `r_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`r_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES (1, 'DesktopOutlined', '系统管理员', 50, 100, 1, '2023-09-29 20:35:14');
INSERT INTO `role` VALUES (2, 'WalletOutlined', '超级管理员', 30, 60, 1, '2023-09-29 21:26:35');
INSERT INTO `role` VALUES (3, 'AliwangwangOutlined', '图书管理员', 20, 40, 1, '2023-09-29 21:26:49');
INSERT INTO `role` VALUES (4, 'DribbbleOutlined', '读者用户', 10, 20, 1, '2023-09-29 21:27:00');
INSERT INTO `role` VALUES (5, 'InfoCircleOutlined', '游客', 5, 10, 1, '2023-10-07 18:09:58');

-- ----------------------------
-- Table structure for role_menu
-- ----------------------------
DROP TABLE IF EXISTS `role_menu`;
CREATE TABLE `role_menu`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `r_id` int NOT NULL COMMENT '角色编号（关联role表）',
  `m_id` int NOT NULL COMMENT '菜单编号（关联menu表）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_role_rm`(`r_id` ASC) USING BTREE,
  INDEX `fk_menu_rm`(`m_id` ASC) USING BTREE,
  CONSTRAINT `fk_menu_rm` FOREIGN KEY (`m_id`) REFERENCES `menu` (`m_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_role_rm` FOREIGN KEY (`r_id`) REFERENCES `role` (`r_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 220 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '权限路由关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role_menu
-- ----------------------------
INSERT INTO `role_menu` VALUES (1, 1, 1);
INSERT INTO `role_menu` VALUES (2, 1, 2);
INSERT INTO `role_menu` VALUES (3, 1, 3);
INSERT INTO `role_menu` VALUES (4, 1, 4);
INSERT INTO `role_menu` VALUES (5, 1, 5);
INSERT INTO `role_menu` VALUES (6, 1, 6);
INSERT INTO `role_menu` VALUES (7, 1, 7);
INSERT INTO `role_menu` VALUES (8, 1, 8);
INSERT INTO `role_menu` VALUES (9, 1, 9);
INSERT INTO `role_menu` VALUES (10, 1, 10);
INSERT INTO `role_menu` VALUES (11, 1, 11);
INSERT INTO `role_menu` VALUES (12, 1, 12);
INSERT INTO `role_menu` VALUES (13, 2, 1);
INSERT INTO `role_menu` VALUES (14, 2, 3);
INSERT INTO `role_menu` VALUES (15, 2, 4);
INSERT INTO `role_menu` VALUES (16, 2, 5);
INSERT INTO `role_menu` VALUES (17, 2, 6);
INSERT INTO `role_menu` VALUES (18, 2, 7);
INSERT INTO `role_menu` VALUES (19, 2, 8);
INSERT INTO `role_menu` VALUES (20, 2, 9);
INSERT INTO `role_menu` VALUES (21, 2, 10);
INSERT INTO `role_menu` VALUES (22, 2, 11);
INSERT INTO `role_menu` VALUES (23, 2, 12);
INSERT INTO `role_menu` VALUES (24, 3, 1);
INSERT INTO `role_menu` VALUES (25, 3, 7);
INSERT INTO `role_menu` VALUES (26, 3, 8);
INSERT INTO `role_menu` VALUES (27, 3, 9);
INSERT INTO `role_menu` VALUES (28, 3, 10);
INSERT INTO `role_menu` VALUES (29, 3, 11);
INSERT INTO `role_menu` VALUES (30, 3, 12);
INSERT INTO `role_menu` VALUES (31, 4, 1);
INSERT INTO `role_menu` VALUES (32, 4, 11);
INSERT INTO `role_menu` VALUES (33, 4, 12);
INSERT INTO `role_menu` VALUES (34, 5, 1);
INSERT INTO `role_menu` VALUES (35, 5, 11);
INSERT INTO `role_menu` VALUES (36, 5, 12);

-- ----------------------------
-- Table structure for sorts
-- ----------------------------
DROP TABLE IF EXISTS `sorts`;
CREATE TABLE `sorts`  (
  `s_id` int NOT NULL COMMENT '编号',
  `s_icon` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图标',
  `s_sort` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类别名称',
  `s_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类别代码',
  `s_status` int NOT NULL COMMENT '状态（0-禁用 1-正常）',
  `s_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`s_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '图书类别表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sorts
-- ----------------------------
INSERT INTO `sorts` VALUES (1, 'KeyOutlined', '历史', 'H', 1, '2023-10-11 01:14:00');
INSERT INTO `sorts` VALUES (2, 'BorderOuterOutlined', '文学', 'L', 1, '2023-10-11 01:18:30');
INSERT INTO `sorts` VALUES (3, 'BgColorsOutlined', '科学', 'S', 1, '2023-10-11 01:22:21');
INSERT INTO `sorts` VALUES (5, 'ScheduleOutlined', '外语', 'E', 1, '2023-10-11 16:24:10');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `u_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '账号',
  `u_pwd` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `u_name` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `u_sex` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别（男/女）',
  `u_birth` date NULL DEFAULT NULL COMMENT '出生日期',
  `u_status` int NOT NULL COMMENT '状态（0-挂失 1-正常）',
  `u_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  PRIMARY KEY (`u_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '账号信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'c4ca4238a0b923820dcc509a6f75849b', '周杰伦', '男', '1989-11-16', 1, '2023-10-26 15:37:28');
INSERT INTO `user` VALUES ('2', 'c4ca4238a0b923820dcc509a6f75849b', '彭于晏', '男', '1970-01-07', 1, '2023-10-26 15:37:28');
INSERT INTO `user` VALUES ('3', 'c4ca4238a0b923820dcc509a6f75849b', '蔡徐坤', '男', '1970-01-07', 1, '2023-10-26 15:37:28');
INSERT INTO `user` VALUES ('4', 'c4ca4238a0b923820dcc509a6f75849b', '史向东', '男', '2004-09-18', 1, '2023-10-26 15:37:28');
INSERT INTO `user` VALUES ('5', 'c4ca4238a0b923820dcc509a6f75849b', '刘德华', '男', '2001-09-30', 1, '2023-10-26 15:37:28');
INSERT INTO `user` VALUES ('6', 'c4ca4238a0b923820dcc509a6f75849b', '王嘉尔', '男', '1959-12-30', 1, '2023-10-26 15:58:56');
INSERT INTO `user` VALUES ('admin', 'c4ca4238a0b923820dcc509a6f75849b', '周星驰', '男', '1959-12-31', 1, '2023-09-29 21:04:23');

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `u_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户账号（关联user表）',
  `r_id` int NOT NULL COMMENT '角色编号（关联role表）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_ur`(`u_id` ASC) USING BTREE,
  INDEX `fk_role_ur`(`r_id` ASC) USING BTREE,
  CONSTRAINT `fk_role_ur` FOREIGN KEY (`r_id`) REFERENCES `role` (`r_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_user_ur` FOREIGN KEY (`u_id`) REFERENCES `user` (`u_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 54 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户权限关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_role
-- ----------------------------
INSERT INTO `user_role` VALUES (36, 'admin', 1);
INSERT INTO `user_role` VALUES (47, '1', 2);
INSERT INTO `user_role` VALUES (48, '2', 3);
INSERT INTO `user_role` VALUES (49, '3', 4);
INSERT INTO `user_role` VALUES (50, '4', 5);
INSERT INTO `user_role` VALUES (51, '5', 4);
INSERT INTO `user_role` VALUES (52, '6', 5);

SET FOREIGN_KEY_CHECKS = 1;
