README
===========

Removes objects from S3 and creates CloudFront invalidations.

Example usage:

```rb
require 'invalidator'

Invalidator.configure do |c|
  c.safe_mode = true
  c.aws_access_key_id = 'XXXX'
  c.aws_secret_access_key = 'XXXX'
  c.aws_region = 'us-east-1'
  c.cf_distribution_id = 'XXXX'
  c.s3_bucket = 'mybucket'
end

# These paths will be invalidated.
paths = %w(
    /path/to/file1.jpg
    /path/to/file2.jpg
)

Invalidator.invalidate(paths)
```


## License

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | Ticean Bennett (<ticean@gmail.com>)
| **Copyright:**       | Copyright (c) 2013 Ticean Bennett
| **License:**         | Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
