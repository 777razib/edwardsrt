import 'package:edwardsrt/feature/home/widget/video_widget.dart';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/style/text_style.dart';

class ViewVideoAndDetails extends StatelessWidget {
   ViewVideoAndDetails({super.key});
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFF3),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFF3),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
        
              const SizedBox(height: 10,),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        // Add your search functionality here
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Search",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              VideoWidget(
                title: '',
                date: '',
                subTitle: '',
                videoUrl: '',
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    Text("Talk of Business Poadcast",style: globalHeadingTextStyle(color: Colors.black,fontSize: 16),),
                    Row(
                      children: [
                        Text("By Jacson Don",style: globalHeadingTextStyle(color: Colors.grey,fontSize: 12),),
                        const SizedBox(width: 2,),
                        Text("Duration: 3.05 min",style: globalHeadingTextStyle(color: Colors.grey,fontSize: 12)) ,
                        const SizedBox(width: 2,),
                        Text("8 days ago",style: globalHeadingTextStyle(color: Colors.grey,fontSize: 12)),
                        const SizedBox(width: 2,),
                        Row(
                          children: [
                            Icon(Icons.visibility),
                            const SizedBox(width: 2,),
                            Text("Views:64K",style: globalHeadingTextStyle(color: Colors.grey,fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.network(""),
                        ),
                        const SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Jacson Don",style: globalHeadingTextStyle(color: Colors.black,fontSize: 14),),
                            const SizedBox(height: 5,),
                            Text("By Jackson Don",style: globalHeadingTextStyle(color: Colors.grey,fontSize: 12),)
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Text('''Discover the mindset, strategy, and tools behind building a successful business (1.03). Each episode dives deep into real founder stories, growth strategies, and lessons from top entrepreneurs. Whether you’re starting your first venture or scaling your next big idea, (2.30) this podcast will help you think smarter, lead better, and grow faster (3.30).''',style: globalHeadingTextStyle(color: Colors.black,fontSize: 14))
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Visibility(
        
                  child: Text(''' ''')),
            ],
          ),
        ),
      ),
    );
  }
}
