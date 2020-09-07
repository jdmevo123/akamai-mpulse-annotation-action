<p align="center">
  <img alt="Akamai logo" width="400" height="400" src="https://www.eiseverywhere.com/file_uploads/8fca94ae15da82d17d76787b3e6a987a_logo_akamai-developer-experience-2-OL-RGB.png"/>
  <h3 align="center">GitHub Action to submit annotations to Akamai mPulse</h3>
  <p align="center">
    <img alt="GitHub license" src="https://badgen.net/github/license/jdmevo123/akamai-mpulse-annotation-action?cache=300&color=green"/>
  </p>
</p>

# Annotate Akamai mPulse  

This action calls the Akamai Api's to submit mPulse annotations to the Akamai platform. 

## Usage

All sensitive variables should be [set as encrypted secrets](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables) in the action's configuration.

## Authentication

You need to declare a `apiToken` secret in your repository.

Follow this guide to retrieve your apiToken.

## Inputs

### `apiToken`
**Required**
API Token: used to authenticate against the Akamai platform

### `title`
**Required**
Title: Currently set to use the following format: 'Repository name - Build build number'

### `time`
**Required** 
current time in UTC milliseconds

### `text`
**Required** 
Text: Currently set to use git commit message

### `domainIds`
**Required** 
List of domain id's: use a comma to seperate. i.e 123,123. Leave blank if not specifying

### `annotationID`
**Required** 
annotationID: Leave blank if the begining of the pipeline, or pull in via the saved artifact

## `workflow.yml` Example

Place in a `.yml` file such as this one in your `.github/workflows` folder. [Refer to the documentation on workflow YAML syntax here.](https://help.github.com/en/articles/workflow-syntax-for-github-actions)

```yaml
steps:
      - name: test
        uses: jdmevo123/akamai-mpulse-annotation-action@1.0
        id: Send Annotation
        with:
          apiToken: ${{ secrets.apiToken }} 
          title: '${{ github.event.repository.name }} - Build: ${{ github.run_number }}'
          time: ''
          text: ${{ github.event.release.tag_name }}
          domainIds: ""
          annotationID: ""
      - name: Upload file annotationID.txt
        uses: actions/upload-artifact@v1
        with:
          name: annotationID
          path: annotationID.txt
        
      - name: Download file annotationID.txt
        uses: actions/download-artifact@v1
        with:
          name: annotationID

      - name: Read file post_message.txt and set output parameter
        id: set_output
        run: echo "::set-output name=annotation_id::$(<annotationID/annotationID.txt)"
      #...... Some other deployment steps
      - name: Annotation - Send end time for deployment
        uses: jdmevo123/akamai-mpulse-annotation-action@1.0
        id: Ammend Annotation
        with:
          apiToken: ${{ secrets.apiToken }} 
          title: '${{ github.event.repository.name }} - Build: ${{ github.run_number }}'
          time: ''
          text: ${{ github.event.release.tag_name }}
          domainIds: ""
          annotationID: ${{ steps.set_output.outputs.annotation_id }}
```
## License

This project is distributed under the [MIT license](LICENSE.md).
