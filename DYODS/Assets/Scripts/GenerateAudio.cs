
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
    public AudioSource firstSource;
    public AudioSource secondSource;
    public AudioSource thirdSource;
    public AudioSource forthSource;
    public float minTransitionTime = 0f;
    public float maxTransitionTime = 2f;
    public float transitionTime = -1f;
 
    void Start()
    {
        firstSource = GetComponent<AudioSource>();
        secondSource = GetComponent<AudioSource>();
        thirdSource = GetComponent<AudioSource>();
        forthSource = GetComponent<AudioSource>();

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

                firstSource.clip = firstClip;
                secondSource.clip = secondClip;
                thirdSource.clip = thirdClip;
                forthSource.clip = forthClip;

                firstSource.PlayOneShot(firstClip, 0.7f);
                secondSource.PlayOneShot(secondClip, 0.7f);
                thirdSource.PlayOneShot(thirdClip, 0.7f);
                forthSource.PlayOneShot(forthClip, 0.7f);

                transitionTime = Random.Range(minTransitionTime, maxTransitionTime);
            }
            else
            {
                transitionTime -= Time.deltaTime;
            }
        }
    }
}

// class Node 
//      {
//         static void createNode()
//                  {
//                      
//                  }

//         static void hasChildren()
//                  {
//                      
//                  }
//         
//
//
//      }

// void Start()
//     {
//         source1 = GetComponent<AudioSource>();
//         source2 = GetComponent<AudioSource>();
//         source3 = GetComponent<AudioSource>();
//         source4 = GetComponent<AudioSource>();
//         source5 = GetComponent<AudioSource>();

//         node1 = CreateNode(source1);
//         node2 = CreateNode(source2);
//         node3 = CreateNode(source3);
//         node4 = CreateNode(source4);
//         node5 = CreateNode(source5);

//         currentNodes = [];
//         currentNodes.Add(node2, node3, node4, node5);
//         currentGraph = CreateGraph(node1, currentNodes);
//         currentNode = currentGraph.root();
//         currentNode.Play();
//     }
 
//     void Update()
//     {
//         if (currentNode.isPlaying)
//         {
//             if (currentNode.hasChildren)
//             {
//                 currentNode.PlayOneShot(currentNode, 0.7f);
//                 currentNodeChildren.PlayOneShot();
//             }
//             else
//             {
//                 currentNode = currentNodeChildren.Random();
//             }
//         }
//     }
// }
