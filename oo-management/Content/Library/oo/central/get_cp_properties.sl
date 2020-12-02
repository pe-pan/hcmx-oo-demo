namespace: oo.central
operation:
  name: get_cp_properties
  inputs:
    - cp_file
    - pom_file:
        private: true
        default: pom.xml
  python_action:
    use_jython: false
    script: "import zipfile\r\nimport xml.etree.ElementTree as ET\r\ndef execute(cp_file, pom_file): \r\n    try:\r\n        archive = zipfile.ZipFile(cp_file, 'r')\r\n        file_content = archive.read(pom_file).decode('UTF-8')\r\n \r\n        root = ET.fromstring(file_content)\r\n        artifact_id = root.find(\"{http://maven.apache.org/POM/4.0.0}artifactId\").text\r\n        version = root.find('{http://maven.apache.org/POM/4.0.0}version').text\r\n        failure = ''\r\n    except Exception as e:\r\n        artifact_id = ''\r\n        version = ''\r\n        failure = 'Exception: ' +str(e)\r\n    return locals()"
  outputs:
    - artifact_id: '${artifact_id}'
    - version: '${version}'
    - failure: '${failure}'
  results:
    - SUCCESS: '${len(failure) == 0}'
    - FAILURE
