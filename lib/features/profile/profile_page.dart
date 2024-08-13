import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scheduler_app_sms/core/widget/app_bar.dart';
import 'package:scheduler_app_sms/core/widget/custom_button.dart';
import 'package:scheduler_app_sms/core/widget/custom_input.dart';
import '../auth/provider/user_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? selected =
        await _picker.pickImage(source: ImageSource.gallery);
        if(selected!=null) {
          var byteImage =await  selected.readAsBytes();
          ref.read(profileImage.notifier).state = byteImage;
        }
    
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    var userNotifer = ref.read(userProvider.notifier);
    return Scaffold(
      appBar: customAppbar(title: 'Profile'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: ref.watch(profileImage) != null
                      ? MemoryImage(ref.watch(profileImage)!)
                      : user.photoUrl!=null?NetworkImage(user.photoUrl!):
                      null,
                  child: ref.watch(profileImage) == null&& user.photoUrl==null
                      ? const Icon(Icons.camera_alt,
                          size: 50, color: Colors.white)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextFields(
              label: 'User name ',
              initialValue: user.name,
              onSaved: (value) {
                userNotifer.setName(value);
              },
            ),
            CustomTextFields(
              label: 'Email',
              initialValue: user.email,
              onSaved: (value) {
                userNotifer.setEmail(value);
              },
              isDigitOnly: true,
            ),
            CustomTextFields(
              label: 'Phone',
              onSaved: (value) {
                userNotifer.setPhone(value);
              },
              initialValue: user.phoneNumber,
            ),
            const SizedBox(height: 20),
            CustomButton(
                text: 'Update Profile',
                onPressed: () {
                  userNotifer.update(ref);
                }),
          ],
        ),
      ),
    );
  }
}
