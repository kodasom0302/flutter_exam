import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'personVo.dart';

class ReadPage extends StatelessWidget {
  const ReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("고다솜"),),
      body: Container(
        padding: EdgeInsets.all(10),
        color: Color(0xffd6d6d6),
        child: _ReadPage(),
      ),
    );
  }
}

class _ReadPage extends StatefulWidget {
  const _ReadPage({super.key});

  @override
  State<_ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<_ReadPage> {

  late Future<PersonVo> pVoFu;

  @override
  void initState() {
    super.initState();
    pVoFu=getPersonVo();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: pVoFu, //Future<> 함수명, 으로 받은 데이타
        builder: (context, snapshot)
    {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('데이터를 불러오는 데 실패했습니다.'));
      } else if (!snapshot.hasData) {
        return Center(child: Text('데이터가 없습니다.'));
      } else {
        //데이터가 있으면
        return Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    child: Text(
                      "${snapshot.data!.name}(${snapshot.data!.gender})",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text("핸드폰",
                        style: TextStyle(fontSize: 20)),
                  ),
                  Container(
                    height: 40,
                    child: Text("${snapshot.data!.hp}",
                        style: TextStyle(fontSize: 20)),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                    child: Text("회사",
                        style: TextStyle(fontSize: 20)),
                  ),
                  Container(
                    height: 40,
                    child: Text("${snapshot.data!.company}",
                        style: TextStyle(fontSize: 20)),
                  )
                ],
              )
            ],
          ),
        );
      }
    });
  }

  Future<PersonVo> getPersonVo() async{
    try {
/*----요청처리-------------------*/
//Dio 객체 생성 및 설정
    var dio = Dio();
// 헤더설정:json으로 전송
    dio.options.headers['Content-Type'] = 'application/json';

// 서버 요청
    final response = await dio.get
    (
    'http://15.164.245.216:9000/api/myclass',
    );
/*----응답처리-------------------*/
    if (response.statusCode == 200) {
//접속성공 200 이면
    print(response.data); // json->map 자동변경

    return PersonVo.fromJson(response.data);

    } else {
//접속실패 404, 502등등 api서버 문제
    throw Exception('api 서버 문제');
    }
    } catch (e) {
//예외 발생
    throw Exception('Failed to load person: $e');
    }
  }

}
