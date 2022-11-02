<template>
  <div>
    <button @click="getDoc">Download Word Document</button>
  </div>
</template>

<script lang="ts">
/* eslint-disable */
  import { Component, Prop, Vue } from "vue-property-decorator";
  import docxtemplater from 'docxtemplater';
  // import JSZip from 'jszip';
  const JSZip = require('jszip');
  // import JSzipUtils from 'jszip-utils';
  const JSzipUtils = require('jszip-utils');
  // import  saveAs  from 'file-saver';
  const saveAs = require('file-saver');
  @Component(
    {
      components: {
      }
    }
  )
  export default class ReportComponent extends Vue {
    getDoc() {
      this.createAndSaveDocument();
    }
    loadFile(url: any,callback: any){
        JSzipUtils.getBinaryContent(url,callback);
    }
    createAndSaveDocument(){
        /*
        *   This required JSON dataset must be fetched from the backend API.
        *   The tags in the template will be replaced by these data.
        *   For demonstrations, I have hardcoded the tesdt dataset
        */
        let dataset = {
          "students": [
            {
              "name": "Mojojojo",
              "deviceMake": "Indrakantha",
              "model": "+94760000000",
              "other_identifiers":"idk other details lol"

            },
          ],
          creater_name: "Joe",
          created_date: "11/2/2022",
          header: "User Students' Details"
        };

        let dataset2 = 
            {
              "name": "Mojojojo",
              "deviceMake": "Indrakantha",
              "model": "+94760000000",
              "other_identifiers":"idk other details lol"
        };
        /* *
        * The template's path must be passed as an arguement .
        * This path can be either a URL(as  in the commented line) or a path relative to the Public folder
        * For testing, I have created a folder named  "ReportTemplates" inside the public folder and it contains my sample
        * template named "template1.docx" .
        * */
        // this.loadFile("https://docxtemplater.com/tag-example.docx",function(error: any,content : any){
          this.loadFile('Word_Template/cellPhone_template_1.docx',function(error: any,content : any){
            if (error) { 
              throw error
            };
            let zip = new JSZip(content);
            let doc = new docxtemplater().loadZip(zip)
            doc.setData(dataset2)
            try {
                doc.render()
            }
            catch (error) {
                // let e = {
                //     message: error.message,
                //     name: error.name,
                //     stack: error.stack,
                //     properties: error.properties,
                // }
                // console.log(JSON.stringify({error: e}));
                // // The error thrown here contains additional information when logged with JSON.stringify (it contains a property object).
                // throw error;
            }
            // docx generating
            let out = doc.getZip().generate({
                type:"blob",
                mimeType: "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                })
            saveAs(out,`MyDocument.docx`);    // You can pass this blob to a custom file saver component in the project.  
        });
    }
  }
</script>


<style scoped lang="scss">
</style>