#!/bin/bash

FEATURE=$1
PAGE=$2

if [ -z "$FEATURE" ] || [ -z "$PAGE" ]; then
  echo "Usage: ./create_page.sh feature page_name"
  exit 1
fi

DIR="lib/features/${FEATURE}/presentation/${PAGE}"
FILE="${DIR}/${PAGE}_page.dart"

mkdir -p $DIR

cat <<EOL > $FILE
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/text_styles.dart';

class ${PAGE^}Page extends ConsumerWidget {
  const ${PAGE^}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      child: Center(
        child: Text(
          '${PAGE^} Page',
          style: AppTextStyles.title,
        ),
      ),
    );
  }
}
EOL

echo "Page created at $FILE"