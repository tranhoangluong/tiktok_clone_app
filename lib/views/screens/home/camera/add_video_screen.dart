import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toptop/database/service/storage_service.dart';
import 'package:toptop/provider/loading_model.dart';
import 'package:toptop/views/widget/text.dart';
import 'package:toptop/views/widget/textformfield.dart';
import 'package:toptop/views/widget/video_player_item.dart';

class AddVideoScreen extends StatelessWidget {
  final File videoFile;
  final String videoPath;

  AddVideoScreen({
    super.key,
    required this.videoFile,
    required this.videoPath,
  });

  final _addVideoFormKey = GlobalKey<FormState>();
  final TextEditingController _songController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<LoadingModel>().isPushingVideo = false;
    return SafeArea(
      child: Scaffold(
        body: Consumer<LoadingModel>(
          builder: (_, isPushingVideo, __) {
            if (isPushingVideo.isPushingVideo) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  CustomText(
                    text: "Pushing Video ....",
                    fontsize: 25,
                    alignment: Alignment.center,
                  ),
                ],
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 2 / 3,
                      height: MediaQuery.of(context).size.height / 2,
                      child: VideoPlayerItem(
                        videoUrl: videoPath,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: _addVideoFormKey,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width - 20,
                            child: CustomTextFormField(
                              controller: _songController,
                              text: 'Song Name',
                              hint: '',
                              validator: (value) {},
                              onSave: (value) {},
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width - 20,
                            child: CustomTextFormField(
                              controller: _captionController,
                              text: 'Caption',
                              hint: '',
                              validator: (value) {},
                              onSave: (value) {},
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancle'),
                              ),
                              const SizedBox(
                                width: 60,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {
                                  context
                                      .read<LoadingModel>()
                                      .changePushingVideo();
                                  StorageServices.uploadVideo(
                                      context,
                                      _songController.text,
                                      _captionController.text,
                                      videoPath);
                                },
                                child: const Text('Share'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}