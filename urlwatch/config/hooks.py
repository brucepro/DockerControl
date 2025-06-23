#!/usr/bin/env python3
"""
urlwatch hooks file for custom processing and notifications
"""

import logging
import requests
import json
from datetime import datetime

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def process_urlwatch_job(job, job_state, urlwatch_config):
    """
    Process each job before checking
    """
    logger.info(f"Processing job: {job.get('name', 'Unknown')}")
    return job

def process_urlwatch_report(job, job_state, urlwatch_config, report):
    """
    Process the report after checking
    """
    if report.error:
        logger.error(f"Error checking {job.get('name', 'Unknown')}: {report.error}")
        return
    
    if report.changed:
        logger.info(f"Change detected for {job.get('name', 'Unknown')}")
        
        # Send custom notifications
        send_custom_notifications(job, report)
        
        # Save screenshot if enabled
        if job.get('screenshot', False):
            save_screenshot(job, report)

def send_custom_notifications(job, report):
    """
    Send custom notifications via various channels
    """
    job_name = job.get('name', 'Unknown')
    job_url = job.get('url', '')
    
    # Discord notification
    discord_webhook = urlwatch_config.get('discord', {}).get('webhook_url')
    if discord_webhook:
        send_discord_notification(discord_webhook, job_name, job_url, report)
    
    # Slack notification
    slack_webhook = urlwatch_config.get('slack', {}).get('webhook_url')
    if slack_webhook:
        send_slack_notification(slack_webhook, job_name, job_url, report)
    
    # Telegram notification
    telegram_config = urlwatch_config.get('telegram', {})
    if telegram_config.get('enabled', False):
        send_telegram_notification(telegram_config, job_name, job_url, report)

def send_discord_notification(webhook_url, job_name, job_url, report):
    """
    Send notification to Discord
    """
    try:
        embed = {
            "title": f"Website Change Detected: {job_name}",
            "description": f"Change detected at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
            "url": job_url,
            "color": 0x00ff00,
            "fields": [
                {
                    "name": "Changes",
                    "value": report.diff[:1000] + "..." if len(report.diff) > 1000 else report.diff,
                    "inline": False
                }
            ]
        }
        
        payload = {
            "embeds": [embed]
        }
        
        response = requests.post(webhook_url, json=payload, timeout=10)
        response.raise_for_status()
        logger.info(f"Discord notification sent for {job_name}")
        
    except Exception as e:
        logger.error(f"Failed to send Discord notification: {e}")

def send_slack_notification(webhook_url, job_name, job_url, report):
    """
    Send notification to Slack
    """
    try:
        payload = {
            "text": f"Website Change Detected: {job_name}",
            "attachments": [
                {
                    "title": job_name,
                    "title_link": job_url,
                    "text": f"Change detected at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n{report.diff[:500]}...",
                    "color": "good"
                }
            ]
        }
        
        response = requests.post(webhook_url, json=payload, timeout=10)
        response.raise_for_status()
        logger.info(f"Slack notification sent for {job_name}")
        
    except Exception as e:
        logger.error(f"Failed to send Slack notification: {e}")

def send_telegram_notification(config, job_name, job_url, report):
    """
    Send notification to Telegram
    """
    try:
        bot_token = config.get('bot_token')
        chat_id = config.get('chat_id')
        
        if not bot_token or not chat_id:
            return
        
        message = f"""
🔔 *Website Change Detected*

*Site:* {job_name}
*URL:* {job_url}
*Time:* {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

*Changes:*
{report.diff[:1000]}{'...' if len(report.diff) > 1000 else ''}
        """.strip()
        
        url = f"https://api.telegram.org/bot{bot_token}/sendMessage"
        payload = {
            "chat_id": chat_id,
            "text": message,
            "parse_mode": "Markdown"
        }
        
        response = requests.post(url, json=payload, timeout=10)
        response.raise_for_status()
        logger.info(f"Telegram notification sent for {job_name}")
        
    except Exception as e:
        logger.error(f"Failed to send Telegram notification: {e}")

def save_screenshot(job, report):
    """
    Save screenshot using screenshot service
    """
    try:
        # This would integrate with the screenshot service
        # Implementation depends on your screenshot service
        logger.info(f"Screenshot saved for {job.get('name', 'Unknown')}")
    except Exception as e:
        logger.error(f"Failed to save screenshot: {e}")

def filter_urlwatch_job(job, job_state, urlwatch_config):
    """
    Filter jobs before processing
    """
    # Example: Skip jobs during maintenance hours
    current_hour = datetime.now().hour
    if 2 <= current_hour <= 4:  # Skip between 2-4 AM
        logger.info(f"Skipping {job.get('name', 'Unknown')} during maintenance hours")
        return False
    
    return True 