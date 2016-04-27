CKEDITOR.config.toolbar = [
['Source','-','Templates']
,['Cut','Copy','Paste','PasteText','-','SpellChecker']
,['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat']
,['Bold','Italic','Underline','Strike','-','Subscript','Superscript']
,'/'
,['NumberedList','BulletedList','-','Outdent','Indent','Blockquote']
,['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock']
,['Link','Unlink','Anchor']
,['Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak']
,'/'
,['Styles','Format','Font','FontSize']
,['TextColor','BGColor']
,['ShowBlocks', 'Maximize']
];

CKEDITOR.editorConfig = function (config) {
    config.filebrowserImageBrowseLinkUrl = "/ckeditor/pictures";
    config.filebrowserImageBrowseUrl = "/ckeditor/pictures";
    config.filebrowserImageUploadUrl = "/ckeditor/pictures";
}