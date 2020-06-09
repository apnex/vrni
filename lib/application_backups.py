# Python SDK Examples
# Script will get all applications and dump to yaml file or create application using data in given yaml file
# If application_backup_action = save : All the applications will be dump to yaml
# If application_backup_action = restore : Applications and Tiers which are created only using Public API restored succesfully.
# e.g Tier with filter criteria for Virtual machine is given as security_groups.name='security_group_scale_100' will be restore correctly since it is done through public APIs
# while manually created Tier with filter criteria for virtual machine as security groups='security_group_scale_100' cannot be configured through public APIs.

import init_api_client
import argparse
import swagger_client
import utilities
import logging
import yaml
import json
import time
from swagger_client.rest import ApiException


logger = logging.getLogger("vrni_sdk")


def main(args):
    application_api = swagger_client.ApplicationsApi()

    if args.application_backup_action == 'save':
        all_apps = []
        params = dict(size=10)
        while True:
            apps = application_api.list_applications(**params)
            for i in apps.results:
                app = application_api.get_application(i.entity_id)
                logger.info("Getting application '{}'".format(app.name))
                tiers = application_api.list_application_tiers(id=app.entity_id)
                app_to_save = dict(name=app.name, no_of_tiers=len(tiers.results), tiers=tiers.to_dict())
                all_apps.append(app_to_save)
                time.sleep(0.025) # make sure we don't hit the vRNI throttle and start getting 429 errors
            if not apps.cursor:
                break
            params['cursor'] = apps.cursor

        logger.info("Storing Application/Tier info to {}".format(args.application_backup_yaml))
        with open(args.application_backup_yaml, 'w') as outfile:
            yaml.dump(all_apps, outfile, default_flow_style=False)

    if args.application_backup_action == 'restore':
        with open(args.application_backup_yaml, 'r') as outfile:
            all_apps = yaml.load(outfile)
        for app in all_apps:
            logger.info("Restoring app '{}'".format(app['name']))
            body = {"name": app['name']}# + '-restored'}
            try:
                created_application = application_api.add_application(body)
                for tier in app['tiers']['results']:
                    tier.pop('application')
                    tier.pop('entity_id')
                    logger.info("\tRestoring tier '{}'".format(tier['name']))
                    application_api.add_tier(created_application.entity_id, tier)
                time.sleep(0.025) # make sure we don't hit the vRNI throttle and start getting 429 errors
            except ApiException as e:
                logger.error("{}".format(json.loads(e.body)))


def parse_arguments():
    parser = init_api_client.parse_arguments()
    parser.add_argument("--application_backup_yaml", action="store",
                        default='application_backup.yml', help="Applications and tiers are saved in this csv")
    parser.add_argument("--application_backup_action", action="store",
                        default='save', help="Action can be 'save' or 'restore'")

    args = parser.parse_args()
    return args


if __name__ == '__main__':
    args = parse_arguments()
    utilities.configure_logging("/tmp")
    api_client = init_api_client.get_api_client(args)
    main(args)
