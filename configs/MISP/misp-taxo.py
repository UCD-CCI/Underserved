from pymisp import PyMISP, MISPTag

misp_url = 'https://misp.underserved.org'
misp_key = 'misp-api-key'
misp_verifycert = False

misp = PyMISP(misp_url, misp_key, misp_verifycert)

def add_custom_tag(tag_name, tag_color="#000080", exportable=True):
    try:
        new_tag = MISPTag()
        new_tag.name = tag_name
        new_tag.colour = tag_color
        new_tag.exportable = exportable

        result = misp.add_tag(new_tag)

        if 'Tag' in result:
            print(f"Successfully added tag: {tag_name}")
        else:
            print(f"Failed to add tag: {result.get('message', 'Unknown error')}")

    except Exception as e:
        print(f"Error adding tag: {str(e)}")

def enable_taxonomies():
    to_enable = {"PAP", "tlp", "rsit", "circl"}
    to_require = {"tlp"}

    try:
        all_taxonomies = misp.taxonomies()

        for taxonomy in all_taxonomies:
            t = taxonomy['Taxonomy']
            namespace = t['namespace']
            taxonomy_id = t['id']

            if namespace in to_enable:
                if not t['enabled']:
                    print(f"Enabling taxonomy: {namespace}")
                    misp.enable_taxonomy(taxonomy_id)
                else:
                    print(f"Taxonomy already enabled: {namespace}")

                misp.enable_taxonomy_tags(taxonomy_id)

                if namespace in to_require and not t['required']:
                    print(f"Setting taxonomy as required: {namespace}")
                    misp.set_taxonomy_required(t, True)
            else:
                print(f"Skipping taxonomy: {namespace}")

        print("Taxonomies enabled and configured successfully")

    except Exception as e:
        print(f"Error managing taxonomies: {str(e)}")

def set_favourite_tags(tag_names):
    for tag_name in tag_names:
        try:
            tag = misp.get_tag(tag_name)
            if 'Tag' in tag:
                tag_obj = tag['Tag']
                if not tag_obj.get('favourite', False):
                    tag_obj['favourite'] = True
                    updated_tag = misp.update_tag(tag_obj)
                    print(f"Set as favourite: {tag_name}")
                else:
                    print(f"Already favourite: {tag_name}")
            else:
                print(f"Tag not found: {tag_name}")
        except Exception as e:
            print(f"Error updating tag '{tag_name}': {str(e)}")

if __name__ == "__main__":
    tags_to_add = [
        {"name": "source:UnderServed", "colour": "#003397", "exportable": True},
        {"name": "source:MISP-Forms", "colour": "#77b2f1", "exportable": True},
        {"name": "type:typo-squatting", "colour": "#00A36C", "exportable": True}
    ]

    for tag in tags_to_add:
        add_custom_tag(tag["name"], tag_color=tag["colour"], exportable=tag["exportable"])

    enable_taxonomies()
