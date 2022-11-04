<template>
  <form class="container" id="help-form">
    <h1>Portal de Ayuda</h1>
    <h3>
      Aqui podras ponerte en contacto con asesores de GAAP I.A.P para recibir
      ayuda de manera digital.
    </h3>
    <div class="section">
      <h2>Paso 1: Selecciona el tema de ayuda</h2>
      <select id="seccion" name="seccion">
        <option value=1>Ayuda con Nutricion</option>
        <option value=2>Ayuda con Medicina</option>
        <option value=3>Ayuda con Dental</option>
        <option value=4>Ayuda con Rehabilitacion</option>
        <option value=5>Ayuda con Tanatologia</option>
      </select>
    </div>

    <div class="section">
      <h2>Paso 2: Ingresa tu informacion de contacto</h2>

      <label for="name" class="form-label">Nombre</label>
      <input
        type="text"
        id="name"
        name="name"
        placeholder="Escribe tu nombre completo aqui"
      />

      <label for="mail" class="form-label">Correo Electronico</label>
      <input
        type="mail"
        id="mail"
        name="name"
        placeholder="ejemplo@correo.com"
      />

      <label for="phone" class="form-label">Telefono</label>
      <input
        type="tel"
        id="phone"
        name="phone"
        placeholder="10 digitos"
      />
    </div>
    <div class="section">
      <h2>Paso 3: Escribe en que necesitas ayuda</h2>
      <textarea
        name="message"
        id="message"
        placeholder="Redacta aqui tu duda en 250 caracteres o menos"
      ></textarea>
    </div>

    <div class="section">
      <h2>Paso 4: Envia tu solicitud de ayuda</h2>
      <input type="submit" name="submit" value="Enviar" />
    </div>

    <p>
      *Una vez enviada tu solicitud un asesor designado de GAAP se pondra en
      contacto contigo a la brevedad para dar seguimiento.
    </p>

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
        usrName:'Steven',
        deviceMake: 'Apple',
        model:'AFSD234',
        otherIdentifiers: "idk other details lol",
        offenseType:'',
        endDate:'',
        yourDepartment:''
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

      createAndSaveDocument(){
       
       let dataset = 
         {
             name: this.usrName,
             deviceMake: this.deviceMake,
             model: this.model,
             other_identifiers: this.otherIdentifiers,
             device_picture: '',
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
           saveAs(out,`MyDocument.docx`);    // You can pass this blob to a custom file saver component in the project.  
       });
      },

    },

  });
</script>


<style scoped lang="scss">
</style>