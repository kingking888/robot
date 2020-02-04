INSERT INTO `message_receive_tache_handler` VALUES (1, 'select CONCAT(a.from_group_name,\'-\',a.from_user_name,\'-\',a.`timestamp`,\'\\r\\n\',a.message) to_message ,\'1\' to_msg_sub_type from message_receive a where a.id=#{id}', NULL, NULL, 'select 1 from dual where not EXISTS(select 1 from message_answer_queue)', 'com.twb.robot.handler.flow.imp.MsgTacheFlowSelectHandler', 1, '发送消息拼接', '0', 'need_answer');
INSERT INTO `message_receive_tache_handler` VALUES (2, 'select a.codea from message_receive_tache_param a where a.param_key=\'answer_group_id\'', NULL, NULL, 'select 1 from dual where not EXISTS(select 1 from message_answer_queue)', 'com.twb.robot.handler.flow.imp.MsgTacheFlowInsertSendMsgHandler', 10, '如果队列为空，送消息', '0', 'need_answer');
INSERT INTO `message_receive_tache_handler` VALUES (3, 'insert INTO  message_answer_queue  set message_receive_id=#{id}', NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowUpdateHandler', 100, '存队列', '0', 'need_answer');
INSERT INTO `message_receive_tache_handler` VALUES (4, '\r\nSELECT\r\n	a.id queue_id,\r\n	b.from_group_id to_group_id,\r\n	b.from_group_name to_group_name,\r\n	b.from_user_id to_user_id,\r\n	b.from_user_name to_user_name,\r\n	CASE b.msg_type\r\nWHEN \'100\' THEN\r\n	\'1\'\r\nELSE\r\n	\'2\'\r\nEND to_msg_sub_type\r\nFROM\r\n	message_answer_queue a\r\nLEFT JOIN message_receive b ON a.message_receive_id = b.id\r\nLIMIT 1', NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowSelectHandler', 1, '回复消息', '0', 'answer_question');
INSERT INTO `message_receive_tache_handler` VALUES (5, NULL, NULL, NULL, 'SELECT\r\n	1\r\nFROM\r\n	DUAL\r\nWHERE\r\n	#{message}!=\'0\'\r\n', 'com.twb.robot.handler.flow.imp.MsgTacheFlowInsertSendMsgHandler', 10, '回复消息', '0', 'answer_question');
INSERT INTO `message_receive_tache_handler` VALUES (6, 'update message_answer_queue a set a.message_answer_id=#{id},a.message_send_id=\'0\' where a.id =#{queue_id}\r\n', NULL, NULL, 'SELECT\r\n	1\r\nFROM\r\n	DUAL\r\nWHERE\r\n	#{message}=\'0\'\r\n', 'com.twb.robot.handler.flow.imp.MsgTacheFlowUpdateHandler', 20, '存历史表', '0', 'answer_question');
INSERT INTO `message_receive_tache_handler` VALUES (7, 'INSERT INTO message_answer_queue_his\r\nSELECT * FROM message_answer_queue a where a.id=#{queue_id}', NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowUpdateHandler', 30, '存历史表', '0', 'answer_question');
INSERT INTO `message_receive_tache_handler` VALUES (8, 'DELETE FROM message_answer_queue  where id=#{queue_id}', NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowUpdateHandler', 40, '存历史表', '0', 'answer_question');
INSERT INTO `message_receive_tache_handler` VALUES (9, 'SELECT\r\n	a.*,\r\n	CONCAT(\r\n		a.from_group_name,\r\n		\'-\',\r\n		a.from_user_name,\r\n		\'-\',\r\n		a.`timestamp`,\r\n		\'\\r\\n\',\r\n		a.message\r\n	) to_message,\r\n	\'1\' to_msg_sub_type\r\nFROM\r\n	message_answer_queue b left join message_receive a on a.id=b.message_receive_id\r\nLIMIT 1\r\n', 'clear', NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowSelectHandler', 50, '下一条待回复数据', '0', 'answer_question');
INSERT INTO `message_receive_tache_handler` VALUES (10, 'select a.codea from message_receive_tache_param a where a.param_key=\'answer_group_id\'', NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowInsertSendMsgHandler', 60, '下一条待回复数据', '0', 'answer_question');
INSERT INTO `message_receive_tache_handler` VALUES (11, 'update message_receive_tache_param a set a.codea=\'1\' where a.param_key=\'group_send_state\' ', NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowUpdateHandler', 1, '准备开始群发', '0', 'group_send_begin_pre');
INSERT INTO `message_receive_tache_handler` VALUES (12, NULL, NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowInsertSendMsgHandler', 1, '准备群发中', '0', 'group_send_pre');
INSERT INTO `message_receive_tache_handler` VALUES (13, NULL, 'clear', NULL, ' select 1 from message_receive_tache_param c where c.param_key=\'group_send_state\' and c.codea!=\'1\'', 'com.twb.robot.handler.flow.imp.MsgTacheFlowSelectHandler', 1, '群发', '0', 'group_send');
INSERT INTO `message_receive_tache_handler` VALUES (14, 'SELECT\r\n	*\r\nFROM\r\n	message_send_his a\r\nWHERE\r\n	a.to_group_id IN (\r\n		SELECT\r\n			b.codea\r\n		FROM\r\n			message_receive_tache_param b\r\n		WHERE\r\n			b.param_key = \'group_send_id\'\r\n	)order by id DESC limit 1', NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowSelectHandler', 10, '群发-获取群发数据', '0', 'group_send');
INSERT INTO `message_receive_tache_handler` VALUES (15, 'select a.codea from message_receive_tache_param a where a.param_key=\'group_all\'', NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowInsertSendMsgHandler', 20, '群发', '0', 'group_send');
INSERT INTO `message_receive_tache_handler` VALUES (16, 'update message_receive_tache_param a set a.codea=\'0\' where a.param_key=\'group_send_state\' ', NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowUpdateHandler', 30, '群发-重置状态', '0', 'group_send');
INSERT INTO `message_receive_tache_handler` VALUES (17, 'DELETE from message_send\r\nWHERE\r\n	 bus_code =\'group_send\'', NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowUpdateHandler', 1, '停止群发', '0', 'group_send_stop');
INSERT INTO `message_receive_tache_handler` VALUES (18, 'update message_receive_tache_param a set a.codea=\'0\' where a.param_key=\'group_send_state\' ', NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowUpdateHandler', 10, '停止群发', '0', 'group_send_stop');
INSERT INTO `message_receive_tache_handler` VALUES (19, '\r\nSELECT\r\nCONCAT(\'在群里喊以下问题或编号(如:q1)，会得到答复：\\r\\n\',\r\n	group_concat(\r\n		a.codea,\r\n		CONCAT(\'.\"\', a.codeb, \'\"\')\r\n	)\r\n) to_message\r\nFROM\r\n	message_receive_tache_param a\r\nWHERE\r\n	a.param_key = \'qa_data\'', NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowSelectHandler', 1, '问答介绍', '0', 'qa_introduce');
INSERT INTO `message_receive_tache_handler` VALUES (20, NULL, NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowInsertSendMsgHandler', 10, '问答介绍', '0', 'qa_introduce');
INSERT INTO `message_receive_tache_handler` VALUES (21, 'SELECT\r\n	CONCAT(\r\n		a.codea,\r\n		\'、\',\r\n		a.codeb,\r\n		\'\\r\\n\',\r\n		a.codec\r\n	) to_message,\'2\' to_msg_sub_type\r\nFROM\r\n	message_receive_tache_param a\r\nWHERE\r\n	a.param_key = \'qa_data\'\r\nand  a.coded=#{message}  ', NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowSelectHandler', 1, '自动问答', '0', 'qa_auto');
INSERT INTO `message_receive_tache_handler` VALUES (22, NULL, NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowInsertSendMsgHandler', 10, '自动问答', '0', 'qa_auto');
INSERT INTO `message_receive_tache_handler` VALUES (23, 'select #{col1} to_user_id ,#{col2} to_user_name,\'200\' to_msg_type,\'2\' to_msg_sub_type,(select codea  from message_receive_tache_param where param_key=\'welcome\') to_message from dual', NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowSelectHandler', 1, 'welcome', '0', 'welcome');
INSERT INTO `message_receive_tache_handler` VALUES (24, '', NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowInsertSendMsgHandler', 10, 'welcome', '0', 'welcome');
INSERT INTO `message_receive_tache_handler` VALUES (26, 'update message_answer_queue a set a.message_answer_id=#{id},a.message_send_id=#{message_send_id} where a.id =#{queue_id}\r\n', NULL, NULL, 'SELECT\r\n	1\r\nFROM\r\n	DUAL\r\nWHERE\r\n	#{message}!=\'0\'\r\n', 'com.twb.robot.handler.flow.imp.MsgTacheFlowUpdateHandler', 21, '存历史表', '0', 'answer_question');
INSERT INTO `message_receive_tache_handler` VALUES (27, 'SELECT\r\n	a.codeb to_group_id,\'311\' to_msg_type\r\nFROM\r\n	message_receive_tache_param a\r\nWHERE\r\n	a.param_key = \'invite_group\'', NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowSelectHandler', 1, '准备数据', '0', 'invite_group');
INSERT INTO `message_receive_tache_handler` VALUES (28, NULL, NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowInsertSendMsgHandler', 10, '发送', '0', 'invite_group');
INSERT INTO `message_receive_tache_handler` VALUES (29, NULL, NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowAnswerHandler', 1, NULL, '0', 'auto_answer');
INSERT INTO `message_receive_tache_handler` VALUES (30, 'SELECT\r\n	\'2\' to_msg_sub_type\r\nFROM\r\n	DUAL', NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowSelectHandler', 10, NULL, '0', 'auto_answer');
INSERT INTO `message_receive_tache_handler` VALUES (31, NULL, NULL, NULL, NULL, 'com.twb.robot.handler.flow.imp.MsgTacheFlowInsertSendMsgHandler', 30, NULL, '0', 'auto_answer');