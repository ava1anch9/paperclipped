document.observe("dom:loaded", function() {
  if($('upload-assets')){
    Asset.ChooseTabByName('upload-assets');
  }
	new Ajax.Updater('search-results', '/admin/assets?source=bucket', {
		asynchronous: true,
		evalScripts: true,
		method : 'get'
	});
});

var Asset = {};

Asset.Tabs = Behavior.create({
  onclick: function(e){
    e.stop();
    Asset.ChooseTab(this.element);
  }
});

Asset.ChooseTab = function (element) {
  var pane = $(element.href.split('#')[1]);
  var panes = $('assets').select('.pane');
  
  var tabs = $('asset-tabs').select('.asset-tab');
  tabs.each(function(tab) {tab.removeClassName('here');});
  
  element.addClassName('here');
  panes.each(function(pane) {Element.hide(pane);});
  Element.show($(pane));
}

Asset.ChooseTabByName = function (tabname) {
  var element = $('tab_' + tabname);
  Asset.ChooseTab(element);
}

Asset.AddToPage = Behavior.create({
  onclick: function(e){
    e.stop();
		Asset.AddAsset(this.element.getAttribute('href'));
  }
});


Asset.ShowBucket = Behavior.create({
  onclick: function(e){
    e.stop();
    var element = $('asset-bucket');
    element.centerInViewport();
    element.toggle();
  }
});

Asset.HideBucket = Behavior.create({
  onclick: function(e){
    e.stop();
    var element = $('asset-bucket');
    element.hide();
  }
});

Asset.WaitingForm = Behavior.create({
  onsubmit: function(e){
    this.element.addClassName('waiting');
    return true;
  }
});

Asset.ResetForm = function (name) {
  var element = $('asset-upload');
  element.removeClassName('waiting');
  element.reset();
}

Asset.AddAsset = function (asset_url) {
  var box = null;
  var index = 0;
	var tabs = $('tabs');
		
  if (tabs) {
		tabs.select('.tab').each(function(tab) {
			if (tab.hasClassName('here')) {
				var page = $('pages').select('.page')[index];
				box = page.select('.textarea')[0];
			}
  		index++;
		});
	} else {
		box = $('content').select('.textarea')[0];
	}

  if(box) {
		if(!!document.selection){
				box.focus();
				var range = (box.range) ? box.range : document.selection.createRange();
				range.text = asset_url;
				range.select();
		}else if(!!box.setSelectionRange){
				var selection_start = box.selectionStart;
				box.value = box.value.substring(0,selection_start) + asset_url + box.value.substring(box.selectionEnd);
				box.setSelectionRange(selection_start + asset_url.length,selection_start + asset_url.length);
    }
    box.focus();
	}

  var bucket = $('asset-bucket');
  bucket.hide();
}

Event.addBehavior({
  '#asset-tabs a'     : Asset.Tabs,
  '#close-link a'     : Asset.HideBucket,
  '#show-bucket a'    : Asset.ShowBucket,
  '#filesearchform a' : Asset.FileTypes,
  '#asset-upload'     : Asset.WaitingForm,
  'div.asset a'       : Asset.AddToPage,
});
