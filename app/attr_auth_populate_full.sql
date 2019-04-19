TRUNCATE public.attr_auth_user, public.master_keypair, public.private_key, public.attribute CASCADE;

INSERT INTO public.attr_auth_user (id, name, access_token, access_token_update, api_username) VALUES (1, 'Test', '$2b$13$ohFggPHd77552g8HBww1OONSvQTN9.RfwphZYY6eGaIARvzBoOCJy', '2018-03-20 00:00:00', 'MartinHeinz'); -- '54agPr4edV9PvyyBNkjFfA))'
INSERT INTO public.attr_auth_user (id, name, access_token, access_token_update, api_username) VALUES (2, 'TestUser', '$2b$13$tBA98L8EtDCiyXrJ4Im0CeJEQ4SeLMD7IG2nH95n86RHmP1d12cVe', '2018-11-10 00:00:00', 'TestUser'); -- '7jagPr4edVdgvyyBNkjdaQ))'
INSERT INTO public.attr_auth_user (id, name, access_token, access_token_update, api_username) VALUES (3, 'TestRunner', '$2b$13$12bPjvAe8C7hDl4lf7mDPOP9y62o2CfD7OKxfkvn3uS7Le3maFpkq', '2018-12-11 00:00:00', 'TestRunner'); -- '7jagPr4edVdghcsBNkjd23))'


INSERT INTO public.attr_auth_user (id, name, access_token, access_token_update, api_username) VALUES (4, 'JohnSmith', '$2b$13$cQK3s6DX5AN./mLnyWKMpeG7jhve9AJ2jmZjONhHP8vN8TpmV34my', '2019-04-19 12:12:34', 'JohnSmith'); -- Provider token: 'aff9da2df081818cb247ec))' User Access Token: 'eyJhbGciOiJIUzUxMiIsImlhdCI6MTU1NTY2NjYzMiwiZXhwIjo0NzExNDI2NjMyfQ.eyJpZCI6NCwidG9rZW4iOiJhZmY5ZGEyZGYwODE4MThjYjI0N2VjKSkifQ.npq_a9Ndiv6r1WGyJuXEjNVdrO1kpKHa0-85hqx5LyAAIXt1g5CbtsgYYG-VUcv47ouOttpopjrWAjzGS_c1-A'
INSERT INTO public.attr_auth_user (id, name, access_token, access_token_update, api_username) VALUES (5, 'JozkoMrkvicka', '$2b$13$R4IL.nsemkPPHrd0Zb7sL.OuQOC0c2QzmADjL67hImueB4E1RMmGa', '2019-04-18 17:15:37', 'JozkoMrkvicka'); -- Provider token: '93c31cb3ac3196997f4901))' User Access Token: 'eyJhbGciOiJIUzUxMiIsImlhdCI6MTU1NTY2NjY1OCwiZXhwIjo0NzExNDI2NjU4fQ.eyJpZCI6NSwidG9rZW4iOiI5M2MzMWNiM2FjMzE5Njk5N2Y0OTAxKSkifQ.BlWbGUa80ycjcG8NyZJZPJEE_hC7-ZE98qdJaeVGeniSxLFnisLQgqynWamXlwFeS9YqYxWprJpkEb3aAMLUrQ'


INSERT INTO public.private_key (id, data, key_update, user_id, challenger_id, device_id) VALUES (1, '\x654a7964565531724844454d2f53764c6e506467656361326e4674685330386c6b4b535555734b53686c784b44715762466b724966362b663944537a7061666b4d4d6d735274624865302f79383353594c6e6250302f46342f3368334f6832503439663037632f5477326e61373462313939336a7277657a6669317076797536332b6d7933306e4f34342b4d747a36736656683748345930586b707a59355078587364547870487872736c2f53786f4f617437774743455573544b4f4641544e3771764472596a4873316a5a626373382f6866476e6e47676567564c63346557454475355161543553367373754b6e4878524559572b66763862395a76486b7241452f744c427156574e473165426b57484a2f685a6741416c6d4c344d414f42516d4f4a43617a6c2b4e52344767684a496c7a3270614a6f68456f7a4b2f664b696e666f78575157676e53496251644541325855715a37452b303972764b414c544b42306e5a30492b4b452f65394372334c344d4a52792b6d30772b6648702f66584e7a65586a333562577151575656436144526a3234695732762b4879526236536a62344d563572787367646b4b467a764455514546454b4b4a614139726b576a5753473132416c6b4e58715457344e576263674255535a694531664531764f554248336b376d567a70634c5957415778615439754b4657355935314c4234414268514e6c51584856727a694e456241514132706d526c4b6e79466d41714a62396e68616c537a36552f534e6f6157644e574c7a596852583837626b356c514253384f4c56717952424b66573641546b41724a56506c484f74544d78387572713876507235564e4a3359324e4348547864767061635066786d4c6d6f30365a7236544b55524b696c774b596458636b6f75316a616a7369526753687246454a356a64517861737869484a6f4d7355577a4154595071456232784e6b795355684468566362556b717a37625957354a69614a41654c4349494a46536f2f61577a66744e716f746536367777424647756179524b5737436672756754456c34515a5a42323959466c796a4154773071426a3465494d62537256334231706131716a4c773568435a78747735622f4265504c35736362747732364b6c7a73476e757a4c4c465753566b744959792b7a58794c52546c7a42646e495674347231414a36517239786d533352556735307771504654656e54452f745a534a4f7631376650527a514b6343315663556f314c697362436c347770725334696b74634e7574397a44414c4c3849575936506e63752b45437369433663706b796e6d7957792b786359383775316577656f3236703950547a34737a586f66397a45494d626c2f2b416e444f736d773d', '2018-12-31 13:16:49.646198+00', 2, 1, 33);

INSERT INTO public.attribute (id, value, private_key_id) VALUES (1, 'GuestToday', 1);
INSERT INTO public.attribute (id, value, private_key_id) VALUES (2, 'GuestTomorrow', 1);

INSERT INTO public.master_keypair (id, data_public, data_master, key_update, attr_auth_user_id) VALUES (1, '\x654a795656637475477a454d2f4258445a782f49335a56493956654b7748434c31446e6b5543427467534c497630637a4a4e647554386c686254334a345842497652367678792b48312b50352f50333538764a7950732f5a386476665834387678394e68727636355050392b354f7258625a774f7a5538486c5834366d4d364272764e6e576243305957727a774a7a35584c623550797a477663312f7a47577531355639304566732b6a5274573578753037704a57744f63652b79703469414751732f5968754d4a796c736334616350627a4f43362f4c52384a70456544614e44574471475a664e41574c6631746a4152393941784b4152693439594147784152696959417a707763597959525244342f4f6d57464f4b4b6168474b43796f742f4c623048554338426f675a6a417477546a506434786935613047494375474e5442675268366b5751654b674c70706f614174496b4138434759535665575159766241572b7934565649754c7a477234744f54444178376f4e626e786f397044485952416a704d683339497642707a496d675a44624d514d766d41483443697772514c5272646a524571574549443039395a35334644725a74664c30325571774561675a4d5179794b7569576d6447515264514a6c6f7376676b687951484e51375a556c543636586a4b596e68777a61317471787645684a5349515a3162477a4a4f732f3166446a7378464358435a334d4b676772567144726c53714c6c4d69772b3443776f4a4c6f7156776b426f41744231744c2f6b7a78644b53554b2b3638366f355479437042556c572f677679385879396e692f505035387548793539766574736a4555716b58434d6a413362613353354c333957545973503357717a4c4847576856594f6d43504b734a5774755441384a71684755744c3334764b4d6b67534d5644353758493957535764726c62706b7539424d534f692f7879714c66553347334b7136577551414950792b4c2f54384b4e53736152376159727974653559382f62506b4c4154524b6b46576452435a47745731577a5a4c32524f7065334b7a5159444657776862396c354c34767665754743394a7767326c6933497562314d6f356f7346416e2b654a46767a6b314e31644f736d67337344532b772b627230757531566c2b785739616842737447374a54544c476b7273564149674d4833352f47475442646271425a576950714d6331556d5a2b5a4c61457542367136747274534774626c426868572b37366342764c384d53766e7935653470593271505957624b70384348663630367a63325a75745743754b5a577139756a497551332f73644e33414e6d314559505879346a4d744d772b3233552b684c326b5935554179556551377a51465866706f4e507a773976594f76644b306e673d3d', '\x654a794e5573744f7844414d2f4a576f357837694e432f7a4b776856585654426f51656b4c6b686f74662b4f783435686a787a534a7337456e686e374e6c3332367a59396864753072712f48647037724b716670386e33647a326b4f457633616a7339646f382b357a364849716e554f6c45674f324d513068385a7979484d416f68594a456d356c302b55794e396e6a4c794357665973414d4a3432664261424964774d536b6d776c556353674a6b7473395a55434234326962514d32494b4955756d65464f6b725962336352635a625772666a342f3366536b733070654456515275556f776f6255597053757064426c364c55596843535131394d6231754d65676372476f7868537145684d45563731617670716d344b62494b6646665546314c4f6e34562b5a3252735242794d5155634a6c574e586b756e70783752506167574c4d49346f4d78647570486b4f4a6e704147556f69534e52573047356d756f68665633486c6f5a6c4b6a6f674d574777306c557578662f424767656c4574626663755237656f7547685169767777497453484458414d6c6971576a5443532f546d5462664238454e5547744263426f6d785064593178756638414a53716262773d3d', '2018-12-31 13:16:49.646198+00', 1);
INSERT INTO public.master_keypair (id, data_public, data_master, key_update, attr_auth_user_id) VALUES (2, '\x654a795656737475477a45512b7858445a78386b3765725658796d43685275347a734748416d344c4649482f7653493573334a75795745336c6c62536b44506b4b4f2f48362f48623466323462612b33382f322b62574e302f504876392b562b50423347374e2f7a37632b4673392f58666a726b646a71556644726764347a565872574d4c326b4d776f6f5a6668734c32364a5062667a75654d61484d735a312f4d34466937415057774a4f436c3162596b77324852643774543353694e317356786e6a4676537357426e47766f4c675952484b456c386567385531665a5a6944714b49454b30626f5a7245726e6144584b4d34435a2b774a3633444532504554505255674664464b7171497250583572474a346455354b396d72676e774a655565457a6f673553774d67516746415a664d7a326f4c4e516d425859416d676b4a5a775164477856366b4768654e4b56617878534452564c774271536d5a46684e594c39516958416c716e693531567736756f49756b724f476f3156786372655a6f427336486d516f2b6133376963777475712f474b596562473965374d6c504f4a524831305230357478515a384736596d54544b4f564379657979656675714d55694645566b4e71794a31684f4373424b4473356b484169546d6152537733697868555a2b456b63335179713632747a54556b3630586c75726c6d6777656d684b4a4d5969522f6670556b52575a6c686979686d57702f7032583257764b56646d504f4770744f6356545a765552425145695949722b703350584a6658732b6159686f7161644c7641525048432f623962716462372f657a702f75413948497568326e7437505941547373774b6f7368686f35416d706970514862523556786c636b6b69377847656b56354565724a37694b6f6f67594642585547444f35653679414d6d6c52636c647a79492f5555475138507936432b5a597076786f5a39426235526136347a4c45535a76514f722f5654544756577861412f5a572b764777645279596e47434e2b552b6353497678532b5061466c452f4f59396f3775486e537132677836416f5357495448423142372b4247445361476b70324338426c78586878674368714a71746f5949433055637975584f515167466537694a41534a746f54364d72464c6c34556c67792f2f7a43764332727675736b4577687231436251374e464a6a2f772f6537316b436a4869752b36653737525a6e7a2f625a62533231464b79336559766b6c664b73496159374353587a7063683950394932384c526b446b4d7536503671654d79504e664c733979444c5662317275596431616e4239792b446546737030525a586d3152586e2f78625a744f6c6d5970384d79694c563646345569356648347a385159626138', '\x654a794e55727475777a414d2f4a584163775a524669577176314955686c4d5937654368674e4d43525a422f44342b6b55475472514a6d696a6f38372b6a5a6474757336765a787530374b38372b74784c497665707376766454756d38306d6a502b762b76566e3074636a3578477155456f3671422b6e527a4d6e71644456394572577556717637504b7666414e4b6a714c4661593951517a324b39534159434a516f636355647135424652644142326a674172704f6c725278486330564b2f31657a747268512b38724c7558352f2f5a736e4a57666f38656f6a576c784a6a73455556556d61506f697547624f4a496b47304170664958644c4853504d495547464d4e516d5479687362645645476d754934383874437678454f62512f3461364f69527644543230454c564f6e596d476741396f7549464442456b62447841325462545846794f4947586a524a3644496c3169583169477365364430524f4a324a4b2f7a4334633565524d366c692b75496f39597257504a574e2b486b35777039533973416c5a6e6533344652417650575a73726762756b6b49462b7a58352b542b35507742486d356b35', '2018-12-31 13:16:49.646198+00', 2);


SELECT pg_catalog.setval('public.attr_auth_user_id_seq', 6, true);
SELECT pg_catalog.setval('public.attribute_id_seq', 3, true);
SELECT pg_catalog.setval('public.private_key_id_seq', 1, true);
SELECT pg_catalog.setval('public.master_keypair_id_seq', 2, true);


-- To dump insert statements from database:
-- (You need to be in directory from which you started DB with `docker-compose up`, e.g. `/postgres`)
-- docker exec -it $(docker-compose ps -q ) pg_dump -U<user> --column-inserts --data-only <db_name> > backup.sql
-- docker exec -it $(docker-compose ps -q ) pg_dump -Upostgres --column-inserts --data-only attr_auth > backup.sql