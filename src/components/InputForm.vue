<template>
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
      <h2>Paso 2: Contact Info</h2>

      <label for="name" class="form-label">usrName</label>
      <input
        type="text"
        id="name"
        name="name"
        placeholder="Escribe tu nombre completo aqui"
        v-model="usrName"
      />

      <label for="mail" class="form-label">Email</label>
      <input
        type="mail"
        id="mail"
        name="name"
        placeholder="yo@gmail.com"
        v-model="email"
      />

      <label for="phone" class="form-label">Phone</label>
      <input
        type="tel"
        id="phone"
        name="phone"
        placeholder="10 digits"
        v-model="phoneNumber"
      />
    </div>
    <div class="section">
      <h2>Paso 3: Help Aid</h2>
      <textarea
        name="message"
        id="message"
        placeholder="message"
        v-model="otherIdentifiers"
      ></textarea>
    </div>

    <!-- <div class="section">
      <p>Photos of the {deviceMake}, {model}, and {other_identifiers} are as follows: </p>
      <input type="file" accept="image/*" @change="onChange"/>
    </div>

    <div class="section">
      <p>Image Preview</p>
      <div>
        <img v-if="device_picture_url" :src="device_picture_url"/>
      </div>
    </div> -->

    <div class="section">
      <p>For the Device Make, Model, and Other Identifiers, between the dates of Start Date and End Date, 
        the following digitally stored evidence related to the crime of Offense Type:  </p>
    </div>

    
    <div>
      <button @click="getDoc">Download Word Document</button>
    </div>
  </form>

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
        email:'',
        device_picture:'',
        device_picture_url:''
      }
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

      createAndSaveDocument(){
       
       let dataset = 
         {
             name: this.usrName,
             deviceMake: this.deviceMake,
             model: this.model,
             other_identifiers: this.otherIdentifiers,
             device_picture: this.device_picture,
             end_Date:'',
             your_Department: this.yourDepartment,
             offense_Type: this.offenseType,

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
           doc.setData(dataset)

           doc.render(dataset)
           
           // try {
               // doc.render(dataset2)
           // }
           // catch (error) {
               // let e = {
               //     message: error.message,
               //     name: error.name,
               //     stack: error.stack,
               //     properties: error.properties,
               // }
               // console.log(JSON.stringify({error: e}));
               // // The error thrown here contains additional information when logged with JSON.stringify (it contains a property object).
               // throw error;
           // }

           // docx generating
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