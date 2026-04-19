def calculate_understanding(accuracy: float, speed: float) -> float:
    return round((0.6 * accuracy) + (0.4 * speed), 4)


def calculate_topic_mastery(understanding_scores: list) -> float:
    if not understanding_scores:
        return 0.0
    return round(sum(understanding_scores) / len(understanding_scores), 4)


def get_level(mastery: float) -> str:
    if mastery > 0.80:
        return 'Strong'
    elif mastery >= 0.60:
        return 'Improving'
    else:
        return 'Weak'


def get_action(level: str) -> str:
    actions = {
        'Weak':      'practice', 
        'Improving': 'review',    
        'Strong':    'pass',      
    }
    return actions.get(level, 'review')


def calculate_mastery_by_difficulty(understanding_scores_by_difficulty: dict) -> dict:
    result = {}
    
    for difficulty, scores in understanding_scores_by_difficulty.items():
        if not scores:
            result[difficulty] = {
                'mastery': 0.0,
                'level': 'Weak',
                'action': 'practice'
            }
            continue
        
        mastery = calculate_topic_mastery(scores)
        level = get_level(mastery)
        action = get_action(level)
        
        result[difficulty] = {
            'mastery': mastery,
            'level': level,
            'action': action
        }
    
    return result