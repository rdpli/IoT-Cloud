TRUNCATE public.acl, public.action, public.device, public.device_data, public.device_type, public.mqtt_user, public.scene, public.scene_action, public."user", public.user_device CASCADE;

INSERT INTO public."user" (id, name, email, access_token, access_token_update) VALUES (1, 'MartinHeinz', 'martin7.heinz@gmail.com', '$pbkdf2-sha256$29000$RGVmYXVsdA$sNWluMfh07f0fPLerXr9jInGOAZk8Yo//lY9pOMv61o', '2018-12-24 10:23:54');  -- '5c36ab84439c45a3719644c0d9bd7b31929afd9f'
INSERT INTO public."user" (id, name, email, access_token, access_token_update) VALUES (2, 'TestUser', 'testuser@domain.com', '$pbkdf2-sha256$29000$RGVmYXVsdA$iAHN9zzOihxXcx2KUbu.5M7a.lbYDt1WLVkBMEHoyfA', '2018-12-10 15:12:34');  -- '5c36ab84439c55a3c196f4csd9bd7b319291239f'
INSERT INTO public."user" (id, name, email, access_token, access_token_update) VALUES (3, 'TestRunner', 'TestRunner@domain.com', '$pbkdf2-sha256$29000$RGVmYXVsdA$OtxkHEIl.rvM9r14TZH8Yw7erxiKcmKPbjtxlbdp1MU', '2018-12-15 15:12:34');  -- '5c36ab84439c55a3c196f4csd9bd7b3d9291f39g'
INSERT INTO public."user" (id, name, email, access_token, access_token_update) VALUES (4, 'TestRunner2', 'TestRunne2r@domain.com', '$pbkdf2-sha256$29000$RGVmYXVsdA$hPz6kfn7Gvs4cZFb7tVPmjl2tmH8k8hLtPI.yUQa7Is', '2018-12-30 15:12:34');  -- '5c36ab84439gden3c196f4csd9bd7b3d9291f39g'

INSERT INTO public.device_type (id, type_id, description, user_id, correctness_hash) VALUES (23525, '12ef8ea3-ba06-4aa9-904e-d5a9f35b09c5', '\x6741414141414263634236614d6f497a5a735079676b6e4e6a78523441316c584a456f6c56384e2d72356f4c75314e556f503435585739676b344270535872307a6e4a656c7271665553737370615a7a364c65557035493339544b397a454f4a34513d3d', 1, '$2b$12$7gceD4ewS6lb/fPN/AuS2eAtUBnQvlCcjfOVMDJCr1jgJy/knoJI2');
INSERT INTO public.device_type (id, type_id, description, user_id, correctness_hash) VALUES (12452, 'dbb028df-87e7-452d-b160-19e03d93f239', '\x674141414141426363423661355150715446345a4c6f45736d4b6d4b334f46717a433237354b6659316b756b765672684a4b63532d686c56636f7346323171544130784c534a6e394f6a337a6f6954655931395f4c6b35496c4934447168523455413d3d', 1, '$2b$12$l5NQRdjq6E7InTQoCkAM.eTBNlpo/s7GCJ8RuNouy2IfEEiVagz..');

INSERT INTO public.device (id, status, device_type_id, owner_id, name, name_bi, correctness_hash) VALUES (23, '\x30', 23525, 1, '\x6741414141414263634236626b4b50526d33302d545268503034416464466f36636e7166764476526d557547766d5f6c4e766b6c6c5f6e55427838734b37396a635f42553052704b7a583368705472554b6a3273656146427958495a3332666161413d3d', 'a36758aa531feb3ef0ce632b7a5b993af3d8d59b8f2f8df8de854dce915d20df', '$2b$12$YtcxXduClOgHe9vVjxzZ4OakMsvcpVhYVQOzi/U/jDb5AeeaQAflG');
INSERT INTO public.device (id, status, device_type_id, owner_id, name, name_bi, correctness_hash) VALUES (45, '\x30', 23525, 2, '\x6741414141414263634236626c2d7875546a324f2d55615461764567674f5f50424c5a527945364f743951714d446f4b726e4b56376232465674364a37666e6b4654316c56635f32754f44646736596a586a45444948415a327a4d754234417934513d3d', '6c0d409f3d4d630303ca1fea9d1d0b2aa9aef33e0480266e23eb24c6b26a3fde', '$2b$12$ssyjw42rMqGrgs30F/5enuZ.UI3IFitD1PJMT/4E5jJfP584AMppW');
INSERT INTO public.device (id, status, device_type_id, owner_id, name, name_bi, correctness_hash) VALUES (34, '\x30', 12452, 2, '\x6741414141414263634236624831746d6a6a483972466337434f784e6b37303773735752356e396f30584e63526d67383339796a713064434f575755793566646e7159476b4d6a476e502d574f5836523163304433683937307962376e387a5a6c773d3d', '19f0eb580950646713d77c0f4e053083fedeb27865191163a72b0c49d3210969', '$2b$12$rDEpuObUojAvzyu8APJDhe/kOJ5JLQzumAN4f62WZ4SWZCX1NJIQK');
INSERT INTO public.device (id, status, device_type_id, owner_id, name, name_bi, correctness_hash) VALUES (37, '\x30', 12452, 2, '\x674141414141426363423663784739574b5773654b7a367038774332325234704b35765a497a5873564c55466d6f39394f666a4e67726a4d3562564467596663484a5365557734433572582d48477737734638625847774e77533063634843646d413d3d', '10f26bdad19613afba7c1e97ba09a67f46306250f7c407d7668ec81c029ede1e', '$2b$12$zYfU5ZicnASq/Ou4BJR6GOy.iGxYlwRBMuwnz/dlm5evD7GwoshdG');

INSERT INTO public.mqtt_user (id, username, password_hash, superuser, user_id, device_id) VALUES (1, 'd:23', 'PBKDF2$sha256$10000$a0HFjEn8VZe04CxJ$Zd2UxhyYvlY5wIqycui58jCKVsNxL1MQ', 0, NULL, 23);  -- device1_pass
INSERT INTO public.mqtt_user (id, username, password_hash, superuser, user_id, device_id) VALUES (2, 'u:1', 'PBKDF2$sha256$10000$8dd35yJLqjFIpeMO$oQwtPcs4FhcZGihX71LtN6fm+yVWcb4v', 0, 1, NULL);  -- password1
INSERT INTO public.mqtt_user (id, username, password_hash, superuser, user_id, device_id) VALUES (3, 'd:34', 'PBKDF2$sha256$10000$+tYVrce5IvbOPREB$haW4Atpabx2giJEeDBwaMIvKf3KNNop0', 0, NULL, 34);  -- device3_pass
INSERT INTO public.mqtt_user (id, username, password_hash, superuser, user_id, device_id) VALUES (4, 'd:37', 'PBKDF2$sha256$10000$1RDrXIISPQKSfLvh$HXv5bYEQe7NepGBLmdp6rOydxuETaWNb', 0, NULL, 37);  -- device4_pass
INSERT INTO public.mqtt_user (id, username, password_hash, superuser, user_id, device_id) VALUES (5, 'd:45', 'PBKDF2$sha256$10000$kOVrAa3VULOtlcxS$BP686anaevC7t2hwxCzfvo5UaxOp1+YA', 0, NULL, 45);  -- device2_pass
INSERT INTO public.mqtt_user (id, username, password_hash, superuser, user_id, device_id) VALUES (6, 'u:2', 'PBKDF2$sha256$10000$NsPHhalfv7Asj8mw$jRzH8ZEMh0B5oKPo2vRhcwhvmk0UIPgC', 0, 2, NULL);  -- password2

-- FOR SERVER USER AND DEBUGGING
INSERT INTO public.mqtt_user (id, username, password_hash, superuser) VALUES (7, 'admin', 'PBKDF2$sha256$10000$J8N0E3qluPAwm8uN$n8jehANuh+6ddOtNmopG0Jem79LzV+X4', 1);  -- password
INSERT INTO public.mqtt_user (id, username, password_hash, superuser) VALUES (8, 'testuser', 'PBKDF2$sha256$10000$qu5hXEoBLNeKuzR7$koo7Ozny5dpZE8Vy8GZVi6kcMvWVPrs6', 0);  -- testuser

INSERT INTO acl (id, mqtt_user_id, username, topic, acc) VALUES (17, 8, 'testuser', 'read', 1);
INSERT INTO acl (id, mqtt_user_id, username, topic, acc) VALUES (18, 8, 'testuser', 'write', 2);
INSERT INTO acl (id, mqtt_user_id, username, topic, acc) VALUES (19, 8, 'testuser', 'both', 3);

INSERT INTO public.acl (id, mqtt_user_id, username, topic, acc) VALUES (1, 1, 'd:23', 'u:1/d:23/+', 1);
INSERT INTO public.acl (id, mqtt_user_id, username, topic, acc) VALUES (2, 1, 'd:23', 'd:23/u:1/+', 2);
INSERT INTO public.acl (id, mqtt_user_id, username, topic, acc) VALUES (3, 1, 'd:23', 'd:23/server/+', 2);
INSERT INTO public.acl (id, mqtt_user_id, username, topic, acc) VALUES (4, 1, 'd:23', 'server/d:23/+', 1);
INSERT INTO public.acl (id, mqtt_user_id, username, topic, acc) VALUES (5, 2, 'u:1', 'u:1/d:23/+', 2);
INSERT INTO public.acl (id, mqtt_user_id, username, topic, acc) VALUES (6, 2, 'u:1', 'd:23/u:1/+', 1);
INSERT INTO public.acl (id, mqtt_user_id, username, topic, acc) VALUES (7, 2, 'u:1', 'u:1/server/+', 2);
INSERT INTO public.acl (id, mqtt_user_id, username, topic, acc) VALUES (8, 2, 'u:1', 'server/u:1/+', 1);
INSERT INTO public.acl (id, mqtt_user_id, username, topic, acc) VALUES (9, 5, 'd:45', 'u:2/d:45/+', 1);
INSERT INTO public.acl (id, mqtt_user_id, username, topic, acc) VALUES (10, 5, 'd:45', 'd:45/u:2/+', 2);
INSERT INTO public.acl (id, mqtt_user_id, username, topic, acc) VALUES (11, 5, 'd:45', 'd:45/server/+', 2);
INSERT INTO public.acl (id, mqtt_user_id, username, topic, acc) VALUES (12, 5, 'd:45', 'server/d:45/+', 1);
INSERT INTO public.acl (id, mqtt_user_id, username, topic, acc) VALUES (13, 6, 'u:2', 'u:2/d:45/+', 2);
INSERT INTO public.acl (id, mqtt_user_id, username, topic, acc) VALUES (14, 6, 'u:2', 'd:45/u:2/+', 1);
INSERT INTO public.acl (id, mqtt_user_id, username, topic, acc) VALUES (15, 6, 'u:2', 'u:2/server/+', 2);
INSERT INTO public.acl (id, mqtt_user_id, username, topic, acc) VALUES (16, 6, 'u:2', 'server/u:2/+', 1);

INSERT INTO public.action (id, name, device_id, name_bi, correctness_hash) VALUES (1, '\x674141414141426359414a716a5a794d7451516962474941394e6f5377466b664859594265776a2d6b6c77726754726246676d446c6e38756b37344636546d694c535854514f536262495564307579666166653975385363757a744d635f796859773d3d', 23, '895a0ac9ff4a7d58642518d20ae1bfd9be96430f9195e5689ce8c87abc131245', '$2b$12$gKla0vp9YqOpSyJvyKpqQu6CgEqmUd7XEFqF/OlPv9i6OAeswI.Zi');
INSERT INTO public.action (id, name, device_id, name_bi, correctness_hash) VALUES (2, '\x674141414141426359414a715361557a4872486655397a5751742d394e4b646a4174724358536549505f6a504c6169694b576a414772773972736631546157724d353949427833775445477175564a50646e3972365a66534c763941446c656241413d3d', 23, '86a638eab77f45b9e0e2fb384471e517664df67cec75c33d724efa8649be357e', '$2b$12$jOfamxBlpNv4BM0Ro3t9uOjLOxkA28J8/82vHAG7m9H.roDBlntPi');
INSERT INTO public.action (id, name, device_id, name_bi, correctness_hash) VALUES (3, '\x674141414141426359414a725f505f38453453306e575446552d7579476b3874334d44657842354c7a4e47484b423672645f70774b7759343162544d5959714176757863724370334242597768374649344636666b73774d4d354a41464d636d71513d3d', 45, '602b766b0a1d7d5a05df61a2d1b33165e35b57d32d2e5b54a16e21514bdbb9a7', '$2b$12$WbfluG1JkeWrO4uUAris6ehnogWkDEJo/s2nnVmu2mjSKBLriikVm');
INSERT INTO public.action (id, name, device_id, name_bi, correctness_hash) VALUES (4, '\x674141414141426359414a733877437a7966456448474f3354556a4b2d45655378442d774645674347593858465f6b45786d7474727a556a4d2d59464b55617953726338794c4a4738555865327a4c744772374c50416c35787957373536587363413d3d', 34, '5c6028f700e377b8fdfea2fc0729d9a6942dbf1906d25a061180d51080e780b4', '$2b$12$dOeB/AhCRZPvBM.asL7sHugMIZIxmH/ZEJ4L0TL5uEuOpsH1ZKn1a');
INSERT INTO public.action (id, name, device_id, name_bi, correctness_hash) VALUES (5, '\x674141414141426359414a734a486369387a7a4b45323332505949582d487737346c594e45745f663745636575726f44717030705748474439365f62614c4532746c5165466c4652656e6d706d467774425a51624c4979426641506142586e6c2d413d3d', 37, '67a6dc5244088db687e7c44e37c3bc36deecfa519a02c79b01090ff5d01f9a4e', '$2b$12$aCPg.rduANJD.DkSAPgcDupLkTP7duPJonBRcqAxMSjPHoCoFB9EC');
INSERT INTO public.action (id, name, device_id, name_bi, correctness_hash) VALUES (6, '\x674141414141426359414a726446544b3167576c4f4b47796e34514357436f7a4171795242686451517078536c486637495a74374e2d37324273376143664e4c4a7432446c38737a5265506b774d546654785f6136484c746c31423155534f5148673d3d', 45, '9e3bada9f77dc2ae690c39f7d46488c57e114e6aa689dcff6ea8ee3ada3dc36f', '$2b$12$Levp4agTMGQxqJS3ncIM.OpIpmAWzetv6Rs2oOYsAsloMA5m1NfOy');

INSERT INTO public.device_data (id, tid, added, num_data, data, device_id, tid_bi, correctness_hash) VALUES (6, '\x674141414141426363355f6a504541425055427634452d565770617a4d5352462d357a364a447536534d5344704c4455736c572d684c6449644765494c566f455f376d536f48722d525a7a55374b6f6a4e364d6e493134444e656e354f6a6a6778773d3d', 2116580122, 464064, '\x654a795656567454346b6f512f697455586e46724d386c6374326f665647344b4b41696f6344786c685a41674373736c3457723533382f3054452f773865784459487253302f50313131393350723259654c394b6e393731617a366254784b7a666e324e3531475776623571797873663879547a4c6b70366478664e74346e5a2f59655269784b544679576c482b4a726777532b3375466768585a6273497353462f72526d797a514e72776b5642734d764368593845713743323177765376526e5243474331397044324c66435067506256446977385645377967466c2b7634556874557573506751775265525056436168656c4d5171413474756f414173387053713864587a4a4d614c354d57643057436b644e7438434a6b536555526558436a77436d2f4441476f35784447474f773730326557356a7754387645704559307866494b2b77774447783262514239514952494b6d51754d4a7030395144476f4177474b684146627745686b41484545352b6871306e41484152634e455475675739677834535847496b4355702b37347a36797169426c494d624847346f796d6a534c6a4968684d5842713441346a78326f42534a4e70514a79346a467038333955464d70632b316732386a49434552575a796c4f347953414c55714d7a4e59614563724477774244566b4472655267305135474855546967444f6c744736734c67684d4678704b654f6f537244454f552f666c7464774141784332595243565842624779414b3845754134794d636764797a37376f58436d506137704f4954364b696256574165394e32424e6b6b434a4c5267744441756b41724144536c2f7633536a583739663463416f495568414d41737637546f492b5771476c705251487848675851747a67695769654d6f41563641427845346f584d374c7741305a474b6b5237424a43775944313454596145593055455868314149313573536d647a54356b5239422b4c654a51694c6d635266364165624b6c5274596f5a554758476a55794f3161494635576b494974795174686d7348437674454a61704a4f556542722b7a2f454e6a43366344764148416a41414e474a326b7858663530714247534f5174766f43697359324846676c6565664555464a7152763472704e466f514b434d7a64776b385a6f4e63544f6c64674a786743565533653544555674517742397370415a2f36594f4d78624d634566394d447743675177386a764151694a4755583541655967677a5067517144536366592b36545168784b4837386d6d4c39744a6d4b356c2f6a692f4145684373746a56656d53746c7751784930306d672b4d64494a777a4273746e54396d306c374a48505276724c7155544764494e35647862686e7063517350707a42326852454e4f59746d745a7a50596d67524c387333763041364a664b6a50716a322b695543616f6e7966444d6262304537576936466b3264364b77364d7a714c353141566f74432b765833754e7977444f4c724a692f2f504675327a5658375370456231343766744b465977416a4a7448574c35346c5431647276727a6b4933445271745649666b7448366e4c33373966505043366e7133656b6b302f4f6554572b2f5230463037575953665a745361374a303766442b2f72627573742b72686c44396e777070325634384f6d322b7a5255585939322b5a3546465837746473527a31756e704c30703333587679474f6a64766b6e2b536a54595878566d7a57547150767a7174735a4c644e3174546b34504e366f7570773956316664665851317a716244385551746b3466426f445672524c33376f4e66736a4e3466797474702b4c476f69754f6d50647131397431352b7652524a71656231574f6d2f4f65336e355737326e7359695255626449667263426e7a36624e59644e6564336169782f4a6b396c397672436d31744b387465373348315554314d78764e725662746864584a61585859624437764b303778426f795276646d7633622b7533342f42516d664c6764704974546b6e7265535834315854672b2b78682b625a66744f5047636376334e2f58645231793770656b373259642f354348657139483436625363425938644e5a38763156567a745753487a7549596e35723572742b37477659583765476d555530306261654b56444b76782b5636532b626461426e4d39376f4358314450795779615a4c6b72615a79535645574a35464c474a4b56737a464f61546e695542716e67345469514d7152704941684c5a53416d2f6a696b6b345372554c4677516f5753315076362b67387841465071', 23, '19b0ac102511621a04272dc74ded56124ec487e4068e32f5274cbf04e7edbd1e', '$2b$12$cHfLcwR4.ulBJXDMXMbJ2.JSAkD4OiHgr1kqw8u/m/tiZ4gqJwIWm');
INSERT INTO public.device_data (id, tid, added, num_data, data, device_id, tid_bi, correctness_hash) VALUES (8, '\x674141414141426363355f6a635264533662795955453532724a32487634726776646637335845367668315f6d436f6c656c2d6c526c744d4c4a4539446f6c705a797561453838422d3434464f3743704564457a776e795f635236567864617a4b513d3d', 2244039737, 466263, '\x654a795656647453347a67512f5a5655586d454b535a59736161726d49596c4a4349514b467964636c69334b647079724d776e594467534b667839315338727975504d517346717456702f54703175667a597732667a592b6d35336e616c464d6376782b6673364b704379666e3832716d653672764777654e3478316c7852316a745a2f42443175434858636b4f467867314a6d507377436a4a6f5941324e326f637950456d3057415668785a51356f3438756c735270664266344574716e5a6b57596c7462647146357453626b7a632b6342707264302b4f4f4b434771737959554c7a5035542b4e4a45325a6767356d45686836474a5434366f6764324b73584e6b647645777073484b624963445430714b53314745416477796766535470776b4f4f6d49513578674f624b715843624f4a567848356755484e43536764645342635a4c424c69534a644d4b4277385a4452303132456b324d49504c6831443647514a3974484244486b6a65634149447877727741697937544f6a42424977515a5732674a426e4a454d34566a416a4b44722f7a6943464b677272432b6352424636445a3654333131596b747337432f6f527765514561554177636c443452346c686c4c6a756746614972707a554149376739704b572f6a4872733454654b6e5a693468516430534f4a5346505441414c506141553467727158593177496c426c646141576e4c4953714b2b7770726d787759624f32564b77764b692f6a615555617343624947446754337a7451374931394f6e4a67454e684f417371534668344a544a316773464a5a44454a387a3859326e394b4850694d76436c6c35366952366155662f375a6471393833394841646432464669744548765651666d6f507562303571714f6569432b4862584e4a505274356c6f632b67686e69464f434c57586f326545654f51366641786d67536b6749726f533277744e65666c6776617448744552373977594b2f78596d5a5977587448327945344a764b2b58657032637236306d474a734b4b4d656d457a68302f59424f316f59333636454674765147676e6b34737076487978676e5945556938624c7a59514d414332694c642f44526b754f557835347165714368783062466148486876566a523159773151436f4d4b4e43624170723038376c37784572426744703344472f4a5a30586333383448554e784a7859413865776d2f70594347785a36683447484c627149486d586a5a57432b47624247524c3674685348746e474454626c5851666c4254743141684f784339335a41377262776f515566616a39322f594f4351394632706243486f4c4a77434b54442f554d4164307658444c617655654b654f787962486f5956532b67474d4c47526c422b547771596f6e52536c6235444457325070645951446345415230763945733930556977786170566c57727a39424f6733366f7a633676593062464e5353564e5872497131424f3059754236636d396c6a475547644a4d664d427a6935626e65666273786144732b767959503938617259477653657a4e4243656d70664436425157444262394d58772b4e646431646858466c387452503136396c66324c656e32797257652f666a30317761757a324d377a317a682f723678337361303672586d505a715032564f315463726f75626e684f5a54667442336b766272386548573337627a665855377061586b5337795341644c706276392b504f47787430547349387636544477634f3056665862467a6d396f615466365831557638654562456b5558755269305a744e576d6637614d58713457376350394d6e6938373133587934654a6c7679326a7a2b6a755a384b52626e53375855675a372b6e593547386e7074754c392b6d61386a422b6a2b584156372b4e78393352357873656a69337238794e5036364c716576356446566253324c5a5565685a764c2f4c37624871657a6c2b6d4f4b4d6e314f746a6b4e3773672b3732384f3072626553744c39744f73474a55714f6e6c6f4c77705770354d79576d2b375062625a785076656343654772656e642b585a344e6470646e542b5171344c7239396b6946734f582b57713169692f4b36503475757633597655784f6f73646c6439674f2b32645842526e656673795377576e3364687150787657416c6f4946363372773052766333712f6a387a514b48363432753757616b66484b564f414c366a6c5a7a504b79386955566553366b547257594a6f72794e4e4d7379314b6170676b6a6c50474d4a65464573597a6e4d6b39554547677145356d496956624a4a4d73597966506d31396366557346574e513d3d', 23, '8cca81860609303ae65ab3ee804a7c0dc2a783eed2c39ee27ee435cfc639825c', '$2b$12$wLVpRu1igPcIS1k1YqQAeetu7seKSxArKLdNqk8aOS68D2Qn9M.4K');
INSERT INTO public.device_data (id, tid, added, num_data, data, device_id, tid_bi, correctness_hash) VALUES (4, '\x674141414141426363355f6a62715f34437242386d5f7034626a4c6a3849766f396a724530326f54755f55346f4b577a615a6438676863557672497371727332475a6f4979517644384a463352714b70505a2d726f67656a7637323367796f2d32413d3d', 2328646538, 471232, '\x654a795656567454346b6f512f697355723768465a704c4d5a617632495771344b497143794f563469676f68775868416c45515873507a766d2b377069655862325964415a71616e2b2b7576762b353831474e572f316e37714a2f4e6932793954504239506f2f58555a3750352b5771766a67555356342f715a5737373948364c634864663378325576505653553035356239582f7064725762344c63564a6a6a6f59665761376738637346352b55504b3763567673435734353755504532337931752b433576677472776b305178386c365a436b33384a466e68533273767952454930706d78494343415a764867476d59522f7a2b42676e466b674141324f454168475541514934414d6f534f557246434243654241413742476177437a424178697a306b62353573456f667055334a4b55645171716c67655152475a67592b675a542f693075774d495541527234303470736744444951476f79785a51784d51446771612b714d4d657053494c73536c645330524663716e77612b72534268374334595a6b35794a5672733543474a387a556c464c59633033454f736f5378553364494b516e6a562b674143685672716b536f4d587250694e4730614f306248484c446e4d6f496e677944506d47535842684b676f56416e444b354149757361673266396a55326e7030534c363441697a67304f635742764144315155352b494a4b69565832534452473249714f47654a6956736a4378495948793869703172434146464443506a6d51684143684144324945716c48515469554a694145616843584a496671473055674179525a304757514b6a78515079733470465a6167566d613348382f7931592f2b37396a4142745947626f4e6262612f444e6d4f6959467359684d43506c553174306464424d5367766a5731507266434e58587a4b705672496869794e77517038344c5861644f474e5171302f47422f4177356d636a78676b757748642f3836573966517147683059436d6f4935556d485743546559526536596f57565857346239534950517935796d70696d4448676b7459347461524852457037716b6b436f706f526e686d41414d366d616e4a392b65746b49536d6664496d44534e49455a713746532b704246546d557944666f52746a433174326c4866564668472b62536c5a4469684d4c6b6869325376627369466330633331754a376567595658466c6e62686d616f492b6c69597a716376443168702b735a677466685868396975563957346b4662684e4a674e443667756e2b594e50636742666854774f3843704c74494b67784d6d32344332676a682f7057313171712b795530335a54483362325541586d486b304b43743473687074776b784159463761547a414f4770644b52747967594e6958594636323679794742716e6e7865346e794b62476672524834664375786b41705556487373735562364b6155536d56557838364b4f576f7357712b7367383556634459666467494f647a643574662f78554139363759647957574a3571462f317a304e5963466830372b48316f5837495a6a65686d6d35313051777532744849365451472b2b445872346336574a316c4c342f4a3769375a46385a366548706346597667366454626a556146546739435452755078327a61616b2b3867712f336d3374664a6576787044464a654f743432373767772b55747a7937466c73642b2b68614a696475387a386664313667334f6e6459305863505a39495262484d334856796d7a574f592f423476782f3367396a4471526131754769356d3057423448472b397468364e526976764f5977612b6a4734766736566d693247556b327a39537838545a75645155732f69304e384d567974676731765a2f6c6234386a305a5042386b39316564396376665a6d4d6e79366554342f39346931314e733375625473494272314a343661566434715254765254767530642b73646a6537414d566452504c2f6250372f765236633764424d325a4d31342b5462503873726a4c5a753954372f7778764c77494739664c56747a723738537363666561396270364d576d656837397a32516e4674542f593334313334655231386e7165363230676e6f507763486c31637a77665a7031753174664c54642b58367a67504e34552b7a43627470386656302f7456754a33347758397857594650714f6379577956355955737168475a654771745570346c632b48486b4f704551726f354647715643784672494a49323878496b5769534f46587a34705879514a53354b465a6b6c632f2f7a384137314e5570413d', 23, 'e7d546fbae9151090d66a378664eaf3450b6ee30a2f7df495343f514497b4b12', '$2b$12$WtybMtflI4FZX32/J/ydOOn5aXbz5um1I9O2VfB2T2YgrLnlIyXYm');
INSERT INTO public.device_data (id, tid, added, num_data, data, device_id, tid_bi, correctness_hash) VALUES (12, '\x674141414141426363355f6a7039654875586144314e3253726379743531724f70664b6c554e79652d4e54736a3963324b2d5a4b7270676f4b597435396d59645458724e7a51504477644474586f674674425852665f643231527a574e42425a32513d3d', 2893054513, 468360, '\x654a795656647479346a67512f52574b3132514b53625a75557a5550684476444c647743624c596f44495a4149415177544343566631393153344b5a743530486c7932703164326e2b2f54785a33704b303939546e2b6e634f466d755a7a462b6a3866543965527747492f4e4b6832646b2f6951766b2b5a33644e6b665978783978394f37314e63336165554e672b3554776c70317349386f586e4d57706f7a445766476a6c4a7a4b4c6c5a4d46687774304d5a4c456c67445357317a71534759377a4637416b6c356762454538612f4d6b2b6f33536d6c4a6849484d2f5057796c704963453143653164773635564c36344a53384745735a5767667541302b4f626334304356474255754d41756155434f73494d7739784236774a7458444268754d47594136736230716b33595567484461646236674670676a704356384b4256557962324573744c54576549446d6c506a6748683934464e4343304a665239345064516d4c3430494d4153306173442b6c4234416455485071484f5550545a47417a736141446d30554962324739532b48755132304278445745636832684e48516e6946663533496b46446c69683744615277464d44386750344545746461594b4d494a694c747041424f694145353762303346494438724830494d344d647257446a6331686a7169424465575947466f57416e4b416f4f6a5644375833344d4838734570432b57774356794c6f4c584b484f5767574f505630554b34636e6c36594f6e64524c412f2b684b6b6475346a6e477754486e697648442b4a357074324a51482f4b37574a4a6858433977424942594b535863436b35394f7a664c7a506b75663872414668704e2b5351757652757254507647384d4362666c76336362532b4d527439554948475174466655456c64574151465251486961506474437450586d5976517365676330416479412f654f474b51493758347a676951666d504233794b31424e47756f396f4644362f7a51657a43447264307539777045784a634f4c474557696b334e5a6972757455516c516270486e72744531364a7542392f2b6a7346724a615350364661724f392f4452623151766b57557165364d764343694e79457a694b3171564e5156464e485a6753427768783461726f75347a515464704d524e414d6374776c5362764335473234767964494e4a464b4d326d3851644b42663641564d7576384843686c5552447043614739685655686638586c6c78562f58646661492f77646450574f434b414f68567a4875626554746a33646c72394258755856615939304957775874365152787457736d2f714e7530367464666769494f38542b33346e6c304c614b4b506e2b66304763366f6a7250784c344247475175637754426e43676344765067743534383735644c3663774a2b6c447376384f37456e52623656656f644e4e5553444d4a456e32792b67493944474d7552716c6363436d444b6b3257532b38673349396d787433796c6b47647a6548362f376e637a70624b7a326270556e714f56317635677577594c436f394f487a4f62316b5256454e64386548513646312f4f69306d2b56695070763938654d35445661353566744c764f2f4748346d31317458615a5a4c7637685a506856327546335957756964354a75344e3935572b32462b327831592f337967334772722b74726f4d4d6970342f5457746e6e646b46473361452f71596f5a31385a306261664b33714c6631324756625951724d7132665866387365676c787a574439566c3454577074544a4e6454784e2b696678326b31474c3439306d4f6b564d356b6a58513257732f66612f46686c6f7866537067385070644c48704e37617a2f4b356b653758436f76694e716b5861756543766d53504d687676343330752b74552b7654514b35574778477046465a745871624c4a5036724879756d586c6e347638514e2b644c6e4732764871713863356d634b6730346c793731536d74546a506175534f692b564566626f6679637171786c3957673976513633366a7a72724a676439564e3859334e74776453654a544c6b69364b6e2f326b58577557677546644a527a45575472714a72314364785373466f6461757848336a387475635a702f30484579484d353639634f356e462b74792b7975575634507934584b736c746543443476647569356f6b774876714366732b55695069532b705348546a4552635231476b7041716e536f547a55455a7a4c626a35444359786e536b57534c4f696b796a69457949444f706b5252654a5173356d4d306c39662f77484378453762', 23, 'c4dedc6cfb2d4fa1d298ccb7a1b3309a93cd241e23b04e33b11deef1e8d1451d', '$2b$12$fKkQzkjg9mh21ACcNdk8/ulKruhf1Qd5JVmOPz1iUszMPGB6qt7a6');
INSERT INTO public.device_data (id, tid, added, num_data, data, device_id, tid_bi, correctness_hash) VALUES (24, '\x674141414141426363355f6a6a666a4536484c54455769563064396548665032424b737a6d4f54422d6c494b4e70627867613631574e7267744e635f6f34584e4756743069525a755174324e4e466d61482d793969466a6c44684c453661704143773d3d', 3312294332, -356708, '\x654a795656647479346a67512f52574b56374956533559736161726d6764734141524a5351424c59624647327363454a6478764970664c7671355a6154505a743577466a58627237394f6e5437633979544d6f2f53702f6c2b717a4956765045764d396d3853724d38396c4d723872526535486b35617553336a324671324e6964762f6d354b72453556564a364839433246557034507146657672685364694366616f6630746558394c6b79752f7242396355412f674e3961445a394d4e4b72514d434c7468484358705036782f537031473546414665565875414634766b594657775a65504c4d4e6e4d507771325a704e2f4342784974754938374631514b777142544343734d4d49344a53704e706744484a66774c344341434f7558636867746f737a5975786743696359434c347744774a305a655977507a5130747a3143435a72594175476355793251654179417171467456546778666a326b4637496a444d4c456f494a365467436f474244504138446742634a425657574e666a424f78524236583875384349734c42714a7038347249414a4f4942573444754755683543425661627770726e4662464154524b467a5134635242455575676742746743536a4c2b456866365a49426a65337349795239433855454e5351776b6742306e78527171307951554934386d776b41735249673068384f345a304a4149476436424977434f5a433877526873466a4e4534645a7367435968735a67317642306370544b4439305a343270793868443151524f7263717048764930424b4c57413664457a796e525549334b67424d494c716c7a377a6b4a616b2f2f664f6c75722f2f66535143314e4a4e4149583775716d5a3732584e41714657616b597a464844676c424569526d5165416d4e4e76516a4e6f70564d4173554e4875674a67346c59447a48627568533068663473434b6737454263516d2b47347970482b617038525a494643365a67493631647370514f3070564a586a5444486943724371526c394f5671594e5843747968685557546a415351787148314a5964436d794a493564354b3278776b36437953646f7364332b574a67446d5470746d4869674c51676b6b3251317675476b48754d4b53554e65544f445a2b717866474639544346416357334c556a64366365756a666b4b4a75676258586d314f4f6d767031324f4b4f73314f7a414a553548626e6934424f7a6e41627647654154584376566a4b58534e446f6132346431774d324f543246324654573737566d48584f573773714d47524469696b36774d7a646e3255506b65326741347a4c4b6e6467393451324a385741766b6d6539735a4f4d346c666e79467730526357336e754136546b74306d4238724d6470717957344e423042666b746d4e31326c635851477557384f5079674a667058613977636a6b416e5956456373756749717446437365646c303075786c566534576a6a44647239616e77336256517147362f79792f2f6c6372765a617a337170515432582b33654e4a69776f4c446f50385070633373646a6d5a365a6575493365566974384f4e43546e72335033382b6c2b4657506473746b384d6f655376733763562b50326f7361734e756d47346e792f506d2f54593639716f666b2f317773314b4451364e61613152502b54336456525a337566794958743958347a5539503577336437643776376f6d6a2f667269575448646e33776b6b647077783875354b422f707074394e6832395068616e787632416a7a6f48535a596b6e6c6269777a6f646159436a7243634748525a3277333471467172325562392b53534d75452b4c486b3971545831756e7233327933687a49573632357a58726a374c4235536361714938655031316c46394c757132637961312f74666379573377327a6258747854387645686b376575754b36316b6b6e366d4463726d3935795455505779586f3357664536587a52334b6b796e66564b4d686a6e66683579336c36314e4e2b36307271635650757a75586b6c52374a4c703661584354734f3050566465394c432b6f64316c316f725072664f637943487464586a742b4a526b656566343637783861392f34717267393879715472666d433579395a7462695a74735178366b78753558376250423271767238636e474a6467532b6f357a78624a486e685368724663784a4567654c4d39354a41704c48674e50575a6f44354c35307847504969557a7a68503439676a6f5261663539485944316e6b455a62364d53392f6666304c793978505a773d3d', 45, '8194716a060f22eaf72bae08c3be6c8c9a481e21cf84bca6b3f0031f0bba38e8', '$2b$12$2uZQ/BhtoCgkt83uO/6aYexXKir3WLwv8wKMQqqxL.ymwYV.tIvdW');
INSERT INTO public.device_data (id, tid, added, num_data, data, device_id, tid_bi, correctness_hash) VALUES (25, '\x674141414141426363355f6a4b6c51444b3752787a2d49516930344954377246785463686e33664f774744484567474a645476505a58516558375f6872724e444f78675843554c31445f467938456f67366f507274784639424a6456654c326f54413d3d', 3317305869, -350734, '\x654a795656567454346b6f512f6973557233714b6d556e6d746c5837674f41694b4367434968355057556b494775566d754968612f76644e542f65412b336132724a424d307466762b3772394c4365382f4b503057613439724c50704f48585044772f4a4e4671744868364b557a6c2b58366572386e4770654c754e707076557666315838754f534e4d636c5656786146566478356c7a446a7a67756862623447685433414635774d7048484a564e59714f4a75775a4a70394f634d766f43463251634a43787547416342482b7a51424256666b7a376e7a7352524a6350537846466f7a65676c42494b442f414a6542744a62634f594f5578594f42546c6752513271736d544f465154467038614d306d5951612b34524958496844622b374f4d426830356c4a49515a613865434e44366c5837757256476530317834493631752f49595951766874534a6e694b4a635349594a6f5745415357764346584f3455354649636d6f424968684274526a6a477973636c50556c4f7966722b516b77734349574143704a795a79706139642b612f3062796946686843714242434856664d43434858374979344576514155474d6365434a52626836424645424351463742777a4542652b51496e67366b706b41596b464b525649484f7144595451584775687776556c7654314a774f595848335745443344414d424b685a6e39783151454b3236416d6c4f324836584a41556d6f534b76624d382b416245694e4e4d534a6c42595536455050517a6f6a326e5251676465696f4e48747a344d55373949752b4d6f6b4f666748766f434c622f665255545876752f302b3947304642633755747a6341454c317441382b2b6c7a46546c4e4b315453483867366652313668344b563365736a394432547470793171357276525153793059543058736a756765416b583857787a33665871506a62647666374b6151423843734e554d65532f4a72784345686b416e63565149456c2b67666350427733695638414f50536368674e7459504b64346b4d366b4551346f6f507a394732436f564e7364666c3376514950627246624847666a4e78486262794a61657151737a365a544e444649354949366a615a614455326a39417344384148516a4764515762397733464a6748764351514e422b42577143486d5948566b726f3535564a76302b466c356167785544695533386f5450675636365a4234706a757a5151744361544d5479535377676830344d337447536f4652676f4544743855636572384266657a4668785750425964454b33692b2b4a6e394e2f48562b557756744b7675424444756f682b5254707333453668425972684e51456d4547713474502b4874392b622f43435a35574b614a544168356455362f79464b34702f47344c5458423656453633576578527651545345562f46353249355767774b4c706f336338613164724437327a716744483257722f2f764f2b584c316f334266486f7044376376757966676f484159666d44547a656c2b7638726235394d64584a384b3152616178756778745a4e395766502b2f4c5946584c6c6b3970336b39336137534f322b496c557538666c34506d383356764f717933307a536532316c572f3955555677747a7333376c3853356c3053355a79636e7565524a76583833484a6c6d6533387a7a6d567762653537384771327a367655303173484c3447587a7448377364704f6f4f6369663232706f742b4a396e472b5379664d79657432736372765968766e6c53452f44317143682b2f7a6f6358475658322f717a646c7239626131717a51572f56706c3344744c6d71505a4d4676774b4439584e36766c4b4f2f7371736e79616442367a7a7673516c386c7171766d52787578665a346c485862374575394f6d6a62723369326e32586b37337354586564515a7a30337239594c726d656b504e396e316574573972537a465a58423156786b4f52445a626d66486f4c716b50333149354f353872657a50717479755671364e582b7a374d61754b6b55737544654e4d3747395a62615673393672634c316e6d37375336616739626f567033317a725a35617339506e7562626a30627235444b616654785665326e6e394d346b39714d616864312b523959714a2f6d7a756d447a4e6973592b41492b78396c6a756c703753744e6b48453169793631536f557a535353716c5a4a486b45592b5a457061723045776d3479676f2f6949624b57575a45464b61695445386a59514b796c396676774662446c4a79', 45, '6ead76f667c014c2d9fb961d2698a332b34194ee0d2e5f54b70105e8254e0e49', '$2b$12$Z3Dj.dZeF0TClv.F4RrHwe5Jc8z.hPmiVgCv4RoRu/EgCjt19wsMK');

INSERT INTO public.scene (id, name, description, correctness_hash, name_bi) VALUES (1, '\x674141414141426359414a70367753725354636867336b616f4766706d746968475a4c4c784a37595f5a7853446c67593771616133554b362d37645a464c31343239557649683039795f456e4a3358396458485470727156726536735670414d51513d3d', '\x674141414141426359414a70593954316b4e4c3265692d686b7a6d346e467a436a7078554e39734e774436517a334e5763425556756d6548314238797646414c6f677a364d2d785f305431436876784d7545502d5744305731344b4c6f57736334304357736a6b647548634858676b5467347a484d67513d', '$2b$12$zwS7/Ooy3pnXfg.C9efU4uXhnDxWVUFggQOJ3BZXDrDr4ogNkN65K', '9c06d92d58a6c3f38fd5dcffef58fedc5502684b1acd4bbede9980803175471a');
INSERT INTO public.scene (id, name, description, correctness_hash, name_bi) VALUES (2, '\x674141414141426359414a6f484f56666872453458356459447767503478583132697239663768327832374a5a43586e3533545231314c676f58356365424e4e58446335747946332d426f357859435f5865746e54524c2d50503243376a6b4c6b673d3d', '\x674141414141426359414a6f625f6a5763437857546271674656573861705267624d78343041684374576348796f3750466c3579775a45325134474e7157325a37694a696d5378366d7533307a663654547a4c4e79592d5a7566684f436861707a5443476e5246733363677a344e3871447256796830727068696a71343551515a44462d4849714b4872576d', '$2b$12$C7jaNqHg2Eczm3PxmmJJgOcAKC7Sl/G0WTJV0GHB.lUg46pBSqCJ2', '0b0a367318926df75879294f1520905ba72d8f1bebe64865645a7e108bfaf3e4');
INSERT INTO public.scene (id, name, description, correctness_hash, name_bi) VALUES (3, '\x674141414141426359414a6f486f6e3776324c4c4f524a4e525830334b4f57545471756d597973336449616c38322d534b4a5763436131385434386a4e57533572395f524a6e7a462d31506635673339314141722d4a6965386c6a6342466f3868673d3d', '\x674141414141426359414a6f46454678534d4c4b6a6e3567633059362d4a4b7249726c316e4d7a3866567a34527766594f56417950364e746e33647573656f66337a564e61593246325f45305a70703056735f4e50724d6f66774742787465703548696b765f76526342704271727a72396154355961723664483366415a364f304d4a6f34526a3779696245', '$2b$12$Z2UTx5oghO1yKLK4LzOEl.H3G71XqERwp9mu8X7nligQ31xEZGPLK', '304d22d3a3443b03d6220b346765c936cc9dfc79c016f1dfb83266352a3c110e');

INSERT INTO public.scene_action (scene_id, action_id) VALUES (2, 5);
INSERT INTO public.scene_action (scene_id, action_id) VALUES (3, 6);
INSERT INTO public.scene_action (scene_id, action_id) VALUES (1, 1);
INSERT INTO public.scene_action (scene_id, action_id) VALUES (3, 4);
INSERT INTO public.scene_action (scene_id, action_id) VALUES (2, 4);
INSERT INTO public.scene_action (scene_id, action_id) VALUES (2, 3);

INSERT INTO public.user_device (user_id, device_id, device_public_session_key, added) VALUES (1, 23, NULL, NULL);
INSERT INTO public.user_device (user_id, device_id, device_public_session_key, added) VALUES (2, 45, NULL, NULL);
INSERT INTO public.user_device (user_id, device_id, device_public_session_key, added) VALUES (2, 34, NULL, NULL);
INSERT INTO public.user_device (user_id, device_id, device_public_session_key, added) VALUES (2, 37, NULL, NULL);

SELECT pg_catalog.setval('public.acl_id_seq', 19, true);
SELECT pg_catalog.setval('public.action_id_seq', 6, true);
SELECT pg_catalog.setval('public.device_data_id_seq', 26, false);
SELECT pg_catalog.setval('public.device_id_seq', 46, false);
SELECT pg_catalog.setval('public.device_type_id_seq', 1, false);
SELECT pg_catalog.setval('public.mqtt_user_id_seq', 8, true);
SELECT pg_catalog.setval('public.scene_id_seq', 3, true);
SELECT pg_catalog.setval('public.user_id_seq', 3, false);


-- public.device_data.added was converted as `int(time.mktime(parser.parse('2018-12-11 00:00:00+00').timetuple()))`

-- To dump insert statements from database:
-- (You need to be in directory from which you started DB with `docker-compose up`, e.g. `/postgres`)
-- docker exec -it $(docker-compose ps -q ) pg_dump -U<user> --column-inserts --data-only <db_name> > backup.sql
-- docker exec -it $(docker-compose ps -q ) pg_dump -Upostgres --column-inserts --data-only postgres > backup.sql