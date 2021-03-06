//import 'package:flutter/material.dart';
//import 'package:myapp/bloc/app_bloc.dart';
//import 'package:myapp/bloc/app_provider.dart';
//import 'package:myapp/entity/comment.dart';
//
//import 'package:myapp/entity/music_details.dart';
//import 'package:myapp/screens/player/state.dart';
//import 'package:myapp/service/comment.dart';
//import 'package:myapp/widgets/common_image.dart';
//
//import 'comment_item.dart';
//import 'top_comment.dart';
//
//class Comment extends StatelessWidget {
//  PlayerState state;
//  Comment(this.state)
//
//  @override
//  Widget build(BuildContext context) {
//    var currentPlayingSong;
//    if (state.currentSongs.length > 0 && state.currentPlayingIndex != -1) {
//      currentPlayingSong = state.currentSongs[state.currentPlayingIndex];
//    }
//    return StreamBuilder<PlaySong>(
//      stream: appBloc.playController.stream,
//      initialData: PlaySong(
//          playLists: appBloc.playing.playLists,
//          playingIndex: appBloc.playing.playingIndex),
//      builder: (context, snapshot) {
//        Song playingSong;
//        if (snapshot.data?.playLists != null) {
//          playingSong = snapshot.data?.playLists[snapshot.data?.playingIndex];
//        }
//        return playingSong == null
//            ? Container()
//            : CommentPage(playingSong: playingSong);
////            : FutureBuilder<CommentModel>(
////                future: getMusicComment(playingSong.id),
////                builder: (context, snapshot) {
////                  if (snapshot.hasError) print(snapshot.error);
////
////                  return snapshot.hasData
////                      ? CommentPage(commentModel: snapshot.data)
////                      : Center(child: CircularProgressIndicator());
////                },
////              );
//      },
//    );
//  }
//}
//
//class CommentPage extends StatefulWidget {
//  final Song playingSong;
//  final int limit = 20;
//  int offset = 0;
//
//  CommentPage({this.playingSong});
//
//  @override
//  State<StatefulWidget> createState() => _CommentPageState(playingSong: playingSong);
//}
//
//
//class _CommentPageState extends State<CommentPage> {
//  final commentEditingController = TextEditingController();
//  final Song playingSong;
//  final int limit = 20;
//  int offset = 0;
//  List<Comments> comments = [];
//  List<HotComments> hotComments = [];
//
//  _CommentPageState({this.playingSong});
//
//  loadingMore () async {
//    CommentModel commentModel = await getMusicComment(playingSong.id);
//    setState(() {
//      offset = comments.length;
//      comments.addAll(commentModel.comments);
//      if (commentModel.hotComments != null && commentModel.hotComments.length > 0) {
//        hotComments = commentModel.hotComments;
//      }
//    });
//  }
//
//  refresh () async {
//    CommentModel commentModel = await getMusicComment(playingSong.id);
//    setState(() {
//      offset = 0;
//      comments.clear();
//      comments.addAll(commentModel.comments);
//      if (commentModel.hotComments != null && commentModel.hotComments.length > 0) {
//        hotComments = commentModel.hotComments;
//      }
//    });
//  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    loadingMore();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//
//    return NotificationListener<ScrollNotification>(
//      onNotification: (ScrollNotification scrollInfo) {
//        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
//          loadingMore();
//        } // offset
//      },
//      child: Column(
//        children: <Widget>[
//          Flexible(
//            flex: 1,
//            child: Scrollbar(
//              child: RefreshIndicator(
//                onRefresh: () async {
//                  this.refresh();
//                },
//                child: ListView.builder(
//                  itemCount: this.hotComments.length +
//                      this.comments.length +
//                      2,
//                  itemBuilder: (BuildContext context, int index) {
//                    if (index == 0) {
//                      return Container(
//                        child: Text(
//                          '热门评论',
//                          style: Theme.of(context).textTheme.title,
//                        ),
//                        margin: EdgeInsets.only(left: 16, top: 16),
//                      );
//                    } else if (index <= this.hotComments.length) {
//                      return TopCommentItem(
//                        comment: this.hotComments[index - 1],
//                        onLikeClicked: (HotComments hotComment) async {
//                          var apiData = await postMusicComment(playingSong.id,
//                              hotComment.commentId, t: hotComment.liked ? 0 : 1, type: 0);
//                          if (apiData.code == 200) {
//                            // 更新显示
//                            setState(() {
//                              hotComments = hotComments.map((editHotComment){
//                                if (hotComment.commentId == editHotComment.commentId) {
//                                  editHotComment.liked = !editHotComment.liked;
//                                  if (editHotComment.liked) {
//                                    editHotComment.likedCount += 1;
//                                  } else {
//                                    editHotComment.likedCount -= 1;
//                                  }
//                                }
//                                return editHotComment;
//                              }).toList();
//                            });
//                          }
//                        },
//                      );
//                    } else if (index == this.hotComments.length + 1) {
//                      return MaterialButton(
//                        onPressed: () {
//
//                        },
//                        child: ListTile(
//                          title: Center(
//                            child: Text('查看更多热门评论'),
//                          ),
//                        ),
//                      );
//                    } else if (index == this.hotComments.length + this.comments.length + 1) {
//                      return MaterialButton(
//                        onPressed: () {
//
//                        },
//                        child: ListTile(
//                          title: Center(
//                            child: SizedBox(
//                              child: Container(
//                                width: 20,
//                                height: 20,
//                                child: CircularProgressIndicator(strokeWidth: 2.0,),
//                              ),
//                            ),
//                          ),
//                        ),
//                      );
//                    }
//                    return CommentItem(
//                        comment: this
//                            .comments[index - 2 - this.hotComments.length]);
//                  },
//                ),
//              ),
//            ),
//          ),
//          TextField(
//            textInputAction: TextInputAction.newline,
//            autofocus: false,
//            onEditingComplete: () {},
//            controller: commentEditingController,
//            maxLines: 3,
//            decoration: InputDecoration(
//              contentPadding: EdgeInsets.all(10.0),
//              labelText: "评论",
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  @override
//  State<StatefulWidget> createState() {
//    // TODO: implement createState
//    return null;
//  }
//}
