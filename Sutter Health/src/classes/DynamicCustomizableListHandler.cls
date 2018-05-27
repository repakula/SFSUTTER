public class DynamicCustomizableListHandler {
  

    // This is the state for the list "app"
    public Set<String> unSelectedNames = new Set<String>();
    public Set<String> selectedNames = new Set<String>();
   

    public DynamicCustomizableListHandler() {
        unSelectedNames.add('Appointment Type');
        unSelectedNames.add('Last Appointment Date');
        unSelectedNames.add('Last Appointment Type');
        unSelectedNames.add('Last AWV Scheduled');
        unSelectedNames.add('Next Appointment Date');
        unSelectedNames.add('Next Appointment Department');
        unSelectedNames.add('Next Appointment Type');
        unSelectedNames.add('Next Appointment Provider');
        unSelectedNames.add('Possible Actions Needed');

        selectedNames.add('Patient Name');
        selectedNames.add('Patient MRN');
        selectedNames.add('Patient DOB');
        selectedNames.add('Gender');
        selectedNames.add('Preferred Communication Method');
        selectedNames.add('Email address');  
    }


    // Create the select options for the two select lists on the page
    public List<SelectOption> getSelectedOptions() { 
        return selectOptionsFromSet(selectedNames);
    }
    public List<SelectOption> getUnSelectedOptions() { 
        return selectOptionsFromSet(unSelectedNames);
    }
    
    private List<SelectOption> selectOptionsFromSet(Set<String> opts) {
        List<String> optionsList = new List<String>(opts);
        optionsList.sort();
        List<SelectOption> options = new List<SelectOption>();
        for (String s : optionsList) {
            options.add(new 
                SelectOption(s,s));
        }
        return options;
    }


    // These properties receive the customization form postback data
    // Each time the [<<] or [>>] button is clicked, these get the contents
    // of the respective selection lists from the form
    public transient List<String> selected   { get; set; }
    public transient List<String> unselected { get; set; }

    // Handle the actual button clicks. Page gets updated via a
    // rerender on the form
    public void DoSelect() {
        moveFields(selected, selectedNames, unSelectedNames);
    }
    public void DoUnselect() {
        moveFields(unselected, unSelectedNames, selectedNames);
    }
    
    private void moveFields(List<String> items, 
            Set<String> moveTo, Set<String> removeFrom) {
        for (String s: items) {
                moveTo.add(s);
                removeFrom.remove(s);
            }
    }
}