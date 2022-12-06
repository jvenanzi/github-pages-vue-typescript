<template>
  <div>
    <div>
      <form class="container" id="help-form">
        <h1>Portal</h1>
        <h3>
          Testing yo
        </h3>
        <div class="section">
          <h2>Paso 1: Select Options</h2>
          <select id="seccion" name="seccion">
            <option value=1>1 options</option>
            <option value=2>2 options</option>
            <option value=3>3 options</option>
            <option value=4>4 options</option>
            <option value=5>5 options</option>
          </select>
        </div>

        <div class="section">
          <h3>Paso 2: Contact Info</h3>

          <label for="name" class="form-label">Name: </label>
          <input
            type="text"
            id="name"
            name="name"
            v-model="docName"
          /><br>

          <label for="mail" class="form-label">Device Make: </label>
          <input
            type="mail"
            id="mail"
            name="name"
            v-model="docDeviceMake"
          /> <br>

          <label for="phone" class="form-label">Device Model: </label>
          <input
            type="tel"
            id="phone"
            name="phone"
            placeholder="10 digits"
            v-model="docModel"
          />
        </div>
        <br>
        <label for="name" class="form-label">Other Identifiers: </label>
          <input
            type="text"
            id="name"
            name="name"
            v-model="docOtherIdentifiers"
          />

        <div class="section">
          <p>Photos of the {deviceMake}, {model}, and {other_identifiers} are as follows: </p>
          <input type="file" accept="image/*" @change="onChange"/>
        </div>

        <!-- <div class="section">
          <p>Image Preview</p>
          <div>
            <img v-if="device_picture_url" :src="device_picture_url"/>
          </div>
        </div> -->

        <div class="section">
          <p>For the Device Make, Model, and Other Identifiers, between the dates of Start Date and End Date, 
            the following digitally stored evidence related to the crime of Offense Type:  </p>
        </div>

      </form>
    </div>
    <div>
      
      <div>
          <button @click="getDoc">Download Word Document</button>
        </div>
    </div>
  </div>
</template>

<script lang="ts">
/* eslint-disable */
  import { Component, Prop, Vue } from "vue-property-decorator";
  import { defineComponent } from "vue";
  import docxtemplater from 'docxtemplater';
  

  // import JSZip from 'jszip';
  const JSZip = require('jszip');
  // import JSzipUtils from 'jszip-utils';
  const JSzipUtils = require('jszip-utils');
  // import  saveAs  from 'file-saver';
  const saveAs = require('file-saver');
  const ImageModule = require('docxtemplater-image-module');
  
  


  export default defineComponent({
    data()
    {
      return{
        usrName:'',
        deviceMake: '',
        model:'',
        otherIdentifiers: '',
        offenseType:'',
        endDate:'',
        yourDepartment:'',
        phoneNumber:'',
        device_picture:'',
        device_picture_url:'',
        showButton:true,
        
      }
    },
    computed:
    {
      docName:
      {
        set(val){this.usrName = val;},
        get(){return;},
      },
      
      docDeviceMake:
      {
        set(val){this.deviceMake = val;},
        get(){return;},
      },

      docModel:
      {
        set(val){this.model = val;},
        get(){return;},
      },

      docOtherIdentifiers:
      {
        set(val){this.otherIdentifiers = val;},
        get(){return;},
      },

      // docDevicePicture:
      // {
      //   set(val){this.usrName = val;},
      //   get(){return;},
      // },

      docEndDate:
      {
        set(val){this.usrName = val;},
        get(){return;},
      },

      docYourDepartment:
      {
        set(val){this.yourDepartment = val;},
        get(){return;},
      },

      docOffenseType:
      {
        set(val){this.offenseType = val;},
        get(){return;},
      },
    },

    methods:
    {
      getDoc() {
        this.createAndSaveDocument();
      },

      loadFile(url: any,callback: any){
          JSzipUtils.getBinaryContent(url,callback);
      },

      onChange(e: any)
      {
        const file = e.target.files[0]
        this.device_picture = file
        this.device_picture_url = URL.createObjectURL(file)
      },

      createAndSaveDocument()
      {
       
       let dataset = 
         {
             name: this.usrName,
             deviceMake: this.deviceMake,
             model: this.model,
             other_identifiers: this.otherIdentifiers,
             device_picture: this.device_picture_url,
            //  device_picture: 'https://docxtemplater.com/xt-pro-white.png',
             end_Date: this.endDate,
             your_Department: this.yourDepartment,
             offense_Type: this.offenseType,

         };


        //  const imageOpts = {
        //   img: dataset.device_picture,
        //   centered: false,
        // }
       
        

       /* *
       * The template's path must be passed as an arguement .
       * This path can be either a URL(as  in the commented line) or a path relative to the Public folder
       * For testing, I have created a folder named  "ReportTemplates" inside the public folder and it contains my sample
       * template named "template1.docx" .
       * */
       // this.loadFile("https://docxtemplater.com/tag-example.docx",function(error: any,content : any){

        
         this.loadFile('Word_Template/cellPhone_template_1.docx',function(error: any,content : any)
         {
              const imageOpts = {
              centered: false,
              getImage: function (tagValue: any, tagName: any) {
                  return new Promise(function (
                      resolve,
                      reject
                  ) 
                  {
                    new JSZip().getBinaryContent(
                          tagValue,
                          function (error: any, content: any) {
                              if (error) {
                                  return reject(error);
                              }
                              return resolve(content);
                          }
                      );
                  });
                }
            }

           if (error) { 
             throw error
           };

           let zip = new JSZip(content);
           let doc = new docxtemplater().loadZip(zip)
          // let doc = new docxtemplater().loadZip(zip).attachModule(new ImageModule(dataset.device_picture))
           
           doc.setData(dataset)

           doc.render(dataset)
           
          //  try {
          //      doc.render(dataset)
          //  }
          //  catch (error: any) {
          //      let e = {
          //          message: error.message,
          //          name: error.name,
          //          stack: error.stack,
          //          properties: error.properties,
          //      }
          //      console.log(JSON.stringify({error: e}));
          //      // The error thrown here contains additional information when logged with JSON.stringify (it contains a property object).
          //      throw error;
          //  }

          //  docx generating
           let out = doc.getZip().generate({
               type:"blob",
               mimeType: "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
               })
           saveAs(out,`JoeDownloadProj.docx`);    // You can pass this blob to a custom file saver component in the project.  
       });
      },

    },

  });
</script>


<style scoped lang="scss">
</style>