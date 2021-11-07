
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


 public class GenerateAudio : MonoBehaviour
{
    public List<AudioClip> audioClips;
    public AudioClip firstClip;
    public AudioClip secondClip; 
    public AudioClip thirdClip;
    public AudioClip forthClip;
    public AudioClip fifthClip; 
    private AudioSource firstSource;
    private AudioSource secondSource;
    private AudioSource thirdSource;
    private AudioSource forthSource;
    private AudioSource fifthSource;
    public float minTransitionTime = 0f;
    public float maxTransitionTime = 2f;
    public float transitionTime = -1f;
    private List<AudioSource> combo_1 = new List<AudioSource>();
    private List<AudioSource> combo_2 = new List<AudioSource>();
 
    void Start()
    {
        firstSource = GetComponent<AudioSource>();
        secondSource = GetComponent<AudioSource>();
        thirdSource = GetComponent<AudioSource>();
        forthSource = GetComponent<AudioSource>();
        fifthSource = GetComponent<AudioSource>();
    }
 
    void Update()
    {
        if (!firstSource.isPlaying)
        {
            if (transitionTime < 0f)
            {
                
                firstClip = audioClips[Random.Range(0, audioClips.Count)];
                secondClip = audioClips[Random.Range(0, audioClips.Count)];
                thirdClip = audioClips[Random.Range(0, audioClips.Count)];
                forthClip = audioClips[Random.Range(0, audioClips.Count)];
                fifthClip = audioClips[Random.Range(0, audioClips.Count)];

                if (firstClip == secondClip)
                {
                    secondClip = audioClips[Random.Range(0, audioClips.Count)];
                }
                if (firstClip == thirdClip)
                {
                    thirdClip = audioClips[Random.Range(0, audioClips.Count)];
                }
                if (firstClip == forthClip)
                {
                    forthClip = audioClips[Random.Range(0, audioClips.Count)];
                }
                if (firstClip == fifthClip)
                {
                    fifthClip = audioClips[Random.Range(0, audioClips.Count)];
                }
                if (secondClip == thirdClip)
                {
                    thirdClip = audioClips[Random.Range(0, audioClips.Count)];
                }
                if (thirdClip == forthClip)
                {
                    forthClip = audioClips[Random.Range(0, audioClips.Count)];
                }
                if (forthClip == fifthClip)
                {
                    fifthClip = audioClips[Random.Range(0, audioClips.Count)];
                }

                firstSource.clip = firstClip;
                secondSource.clip = secondClip;
                thirdSource.clip = thirdClip;
                forthSource.clip = forthClip;

                firstSource.PlayOneShot(firstClip, 1.0f);
                secondSource.PlayOneShot(secondClip, 1.0f);
                thirdSource.PlayOneShot(thirdClip, 1.0f);
                forthSource.PlayOneShot(forthClip, 1.0f);

                transitionTime = Random.Range(minTransitionTime, maxTransitionTime);
            }
            else
            {
                transitionTime -= Time.deltaTime;
            }
        }
    }
}